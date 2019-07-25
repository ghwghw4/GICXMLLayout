//
//  GICDataContext+JavaScriptExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/17.
//

#import "GICDataContext+JavaScriptExtension.h"
#import "JSValue+GICJSExtension.h"
#import "NSObject+GICDataBinding.h"
#import "GICJSElementDelegate.h"
#import "GICXMLLayoutPrivate.h"

@implementation NSObject (JSScriptDataBinding)
-(void)gic_updateDataContextFromJsValue:(JSManagedValue *)jsValue{
    if([jsValue.value isNull])
        return;
    if([self gic_dataPathKey] && [jsValue.value isObject]){ //以防array 无法获取value
        JSValue *pathValue = jsValue.value[[self gic_dataPathKey]];
        // 用来监听gic_dataPathKey对应的属性改变事件
        JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self inContext:[jsValue.value context]];
        @weakify(self)
        selfValue[@"_updateBindPath"] = ^(JSValue *value){
            @strongify(self)
            [self gic_updateDataContext:[value gic_ToManagedValue:self]];
        };
        [jsValue.value invokeMethod:@"addElementBind" withArguments:@[selfValue,[self gic_dataPathKey],@"_updateBindPath"]];
        jsValue = [pathValue gic_ToManagedValue:self];
        // 关键代码
        [self setGic_DataContext:jsValue updateBinding:NO];
    }
    
    for(GICDataBinding *b in [self gic_Bindings]){
        [b gic_updateDataContext:jsValue];
    }
    
    for(GICBehavior *d in [self gic_Behaviors].behaviors){
        [d gic_updateDataContext:jsValue];
    }
    
    for(id e in [self gic_subElements]){
        if([e gic_isAutoInheritDataModel]){
            [e gic_updateDataContext:jsValue];
        }
    }
}
@end



@implementation GICDirectiveFor (JSScriptExtension)
//-(void)gic_updateDataContextFromJsValue:(JSValue *)jsValue{
//    [super gic_updateDataContextFromJsValue:jsValue];
//    [self updateDataSourceFromJsValue:jsValue];
//}

-(void)updateDataSourceFromJsValue:(JSManagedValue *)jsValue{
    [self removeAllItems];
    if([jsValue.value gic_isArray]){
        jsValue.value[@"forDirective"] = self;
        [jsValue.value invokeMethod:@"toForDirector" withArguments:@[jsValue.value[@"forDirective"]]];
    }else if ([jsValue.value isObject]){
        JSManagedValue *mv = [[jsValue.value.context.globalObject invokeMethod:@"ObjectToArray" withArguments:@[jsValue.value]] gic_ToManagedValue:self];
        [self setGic_DataContext:mv];
    }
}
- (void)addItem:(JSValue *)item {
    NSInteger index = [self initIndexMethodAndReturnIndex:item];
    [self addAElement:[item gic_ToManagedValue:self.target] index:index];
}

-(NSInteger)initIndexMethodAndReturnIndex:(JSValue *)item{
    if([item isObject]){
        @weakify(self)
        item[@"__index__"] = ^(){
            @strongify(self)
            JSValue *array = [(JSManagedValue *)[self gic_DataContext] value];
            return [array invokeMethod:@"indexOf" withArguments:@[[JSContext currentThis]]];
        };
        return [[item invokeMethod:@"__index__" withArguments:nil] toInt32];
    }
    return [[[(JSManagedValue *)[self gic_DataContext] value] invokeMethod:@"indexOf" withArguments:@[item]] toInt32];
}

- (void)insertItem:(JSValue *)item{
    NSInteger index = [self initIndexMethodAndReturnIndex:item];
    [self insertAElement:[item gic_ToManagedValue:self.target] index:index];
}

-(void)deleteItemWithStartIndex:(NSInteger)index withCount:(NSInteger)count{
    NSArray *items =  [self targetSubElements];
    NSMutableArray *deleteArray = [NSMutableArray array];
    if(index >=0){
        for(NSInteger start = index;start < (index+count) && start < items.count;start++){
            [deleteArray addObject:items[start]];
        }
    }else if(index <0){
        for(NSInteger start = items.count + index;start < (items.count + index + count) && start <items.count;start ++){
            [deleteArray addObject:items[start]];
        }
    }
    if(deleteArray.count>0){
        [self.target gic_removeSubElements:deleteArray];
    }
}

-(void)deleteAllItems{
    [self.target gic_removeSubElements:[[self.target gic_subElements] copy]];
}
@end



/**
 实现js 跟 native 之间的数据绑定
 */
@implementation GICDataBinding (JSScriptExtension)
-(void)refreshExpressionFromJSValue:(JSManagedValue *)jsValue needCheckMode:(BOOL)needCheckMode{
    NSString *resultString = nil;
    JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self.target inContext:[jsValue.value context]];
    if(jsValue.value && ![jsValue.value isNull] && ![jsValue.value isUndefined]){
        if(self.expression.length == 0){
            resultString = [jsValue.value toString];
        }else{
            NSString *js = [NSString stringWithFormat:@"return %@",self.expression];
            JSValue *result = [jsValue.value invokeMethod:@"executeBindExpression" withArguments:@[js,selfValue]];
            resultString = [result isUndefined]?@"":[result toString];
        }
    }
    
    id value = nil;
    if(self.valueConverter){
        value = [self.valueConverter convert:resultString?:@""];
    }else{
        value = [self.attributeValueConverter convert:resultString?:@""];
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
            [self refreshExpressionFromJSValue:[value gic_ToManagedValue:self.target] needCheckMode:NO];
    };
    [jsValue.value invokeMethod:@"addElementBind" withArguments:@[selfValue,self.expression,@"_updateBindExp"]];
    
    // 实现双向绑定
    if(self.bingdingMode == GICBingdingMode_TowWay){
        if([self.target respondsToSelector:@selector(gic_createTowWayBindingWithAttributeName:withSignalBlock:)]){
            @weakify(self)
            [self.target gic_createTowWayBindingWithAttributeName:self.attributeName withSignalBlock:^(RACSignal *signal) {
                [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable newValue) {
                    // 判断原值和新值是否一致，只有在不一致的时候才会触发更新
                    @strongify(self)
                    isTowwayUpdate = YES;
                    jsValue.value[self.expression] = newValue;
                    isTowwayUpdate = NO;
                }];
            }];
        }
    }
}
@end




@implementation GICEvent(JSScriptExtension)
-(void)excuteJSBindExpress:(NSString *)js withValue:(id)value{
    JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self.target inContext:nil];
    if(value && ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])){
        [selfValue invokeMethod:@"_fireEvent_" withArguments:@[js,value]];
    }else if ([value isKindOfClass:[UITouch class]]){
        UITouch *t = value;
        CGPoint p = [t locationInView:t.view];
        [selfValue invokeMethod:@"_fireEvent_" withArguments:@[js,[JSValue valueWithPoint:p inContext:selfValue.context]]];
    }else{
        if(value){
            [selfValue invokeMethod:@"_fireEvent_" withArguments:@[js,value]];
        }else{
            [selfValue invokeMethod:@"_fireEvent_" withArguments:@[js]];
        }
        
    }
}
@end

