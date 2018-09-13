//
//  GICJSElementValue.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import "GICJSElementValue.h"
#import "GICTapEvent.h"

#import "NSObject+GICDataBinding.h"
#import "GICDataBinding.h"


@implementation GICDataBinding (GICJSScript)
-(void)refreshExpressionFromJSValue:(JSValue *)jsValue needCheckMode:(BOOL)needCheckMode{
    NSString *jsCode = self.expression;
    if(jsCode.length == 0){
        jsCode = @"this";
    }
    JSValue *selfValue = [GICJSElementValue creatValueFrom:self.target toContext:[jsValue context]];
    NSString *js = [NSString stringWithFormat:@"return %@",jsCode];
    JSValue *result = [jsValue invokeMethod:@"executeBindExpression" withArguments:@[js,selfValue]];
    NSString *valueString = [result isUndefined]?@"":[result toString];
    id value = nil;
    if(self.valueConverter){
        value = [self.valueConverter convert:valueString];
    }else{
        value = [self.attributeValueConverter convert:valueString];
    }
    self.attributeValueConverter.propertySetter(self.target,value);
    if(self.valueUpdate){
        self.valueUpdate(value);
    }
    if(!needCheckMode || self.bingdingMode == GICBingdingMode_Once){
        return;
    }
    
    __block BOOL isTowwayUpdate = NO;
    // 实现单向绑定
    @weakify(self)
    selfValue[@"_updateBindExp"] = ^(JSValue *value){
        @strongify(self)
        if(!isTowwayUpdate)
            [self refreshExpressionFromJSValue:value needCheckMode:NO];
    };
    [jsValue invokeMethod:@"addElementBind" withArguments:@[selfValue,jsCode,@"_updateBindExp"]];
    
    // 实现双向绑定
    if(self.bingdingMode == GICBingdingMode_TowWay){
        if([self.target respondsToSelector:@selector(gic_createTowWayBindingWithAttributeName:withSignalBlock:)]){
            JSValue *weakJsValue = jsValue;
            @weakify(self)
            [self.target gic_createTowWayBindingWithAttributeName:self.attributeName withSignalBlock:^(RACSignal *signal) {
                [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable newValue) {
                    // 判断原值和新值是否一致，只有在不一致的时候才会触发更新
                    // TODO:这里可能会引起内存异常，因为这里对jsValue捕获了，因此要想办法修改
                    @strongify(self)
                    isTowwayUpdate = YES;
                    weakJsValue[self.expression] = newValue;
                    isTowwayUpdate = NO;
                }];
            }];
        }
    }
}

-(void)updateDataSourceFromJsValue:(JSValue *)jsValue{
    [self refreshExpressionFromJSValue:jsValue needCheckMode:YES];
}
@end

@implementation GICJSElementValue{
    NSMutableDictionary<NSString *,JSManagedValue *> *managedValueDict;
}
-(id)initWithElement:(id)element{
    self = [super init];
    _element = element;
    managedValueDict = [NSMutableDictionary dictionary];
    return self;
}

-(void)updateDataContextFromJsValue:(JSValue *)jsValue element:(id)element{
    for(GICDataBinding *b in [element gic_Bindings]){
        [b updateDataSourceFromJsValue:jsValue];
    }
    
    for(id e in [element gic_subElements]){
        [self updateDataContextFromJsValue:jsValue element:e];
    }
}

-(void)setDataSource:(JSValue *)dataSource{
    managedValueDict[@"dataSource"] = [JSManagedValue managedValueWithValue:dataSource];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedValueDict[@"dataSource"] withOwner:self];
    // 更新数据源
    [self updateDataContextFromJsValue:dataSource element:self.element];
//    NSString *name = [self.element gic_ExtensionProperties].name;
//    JSValue *selfValue = [dataSource context][name];
//    selfValue[@"ok"] = ^{
//        NSLog(@"");
//    };
//    [dataSource invokeMethod:@"addElementBind" withArguments:@[selfValue,@"name",@"ok"]];
}

-(JSValue *)dataSource{
    return managedValueDict[@"dataSource"].value;
}

+(JSValue *)creatValueFrom:(id)element toContext:(JSContext *)jsContext{
    NSString *name = [element gic_ExtensionProperties].name;
    if(!name){
        // 随机生成一个名称
        int  r = arc4random() % 10000;
        name = [NSString stringWithFormat:@"_auto%.4d_%.0f",r,[[NSDate date] timeIntervalSince1970]*1000];
        [element gic_ExtensionProperties].name = name;
    }
    JSValue *selfValue = jsContext[name];
    if(!selfValue.isUndefined){//说明已经存在
        return selfValue;
    }
    GICJSElementValue *v = [[GICJSElementValue alloc] initWithElement:element];
    jsContext[name] = v;
    selfValue = jsContext[name];
    
    NSDictionary<NSString *, GICAttributeValueConverter *> *ps = [GICElementsCache classAttributs:[element class]];
    NSString *attStrings = [ps.allKeys componentsJoinedByString:@","];
    [selfValue invokeMethod:@"_elementInit" withArguments:@[attStrings]];
    return selfValue;
}

- (void)setEvent:(NSString *)eventName eventFunc:(JSValue *)eventFunc{
    managedValueDict[eventName] = [JSManagedValue managedValueWithValue:eventFunc];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedValueDict[eventName] withOwner:self];
    GICEvent *event = [_element gic_event_findFirstWithEventNameOrCreate:eventName];
    @weakify(self)
    [event.eventSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [(self-> managedValueDict[eventName]).value callWithArguments:nil];
    }];
}

-(id)getAttValue:(NSString *)attName{
    GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[_element class]][attName];
    if(p && p.propertyGetter){
        id v = p.propertyGetter(_element);
        return [p valueToString:v];
    }
    return nil;
}

-(JSValue *)getSuperElement:(JSValue *)selfValue{
    id superEl = [self.element gic_getSuperElement];
    if(superEl){
        return [GICJSElementValue creatValueFrom:superEl toContext:[selfValue context]];
    }
    return nil;
}

- (void)setAttValue:(NSString *)attName newValue:(NSString *)newValue {
    GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[_element class]][attName];
    if(p){
        p.propertySetter(_element, [p convert:newValue]);
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"<GICJSElementValue>: elementName = %@, name = %@",[[_element class] gic_elementName],  [_element gic_ExtensionProperties].name];
}
@end
