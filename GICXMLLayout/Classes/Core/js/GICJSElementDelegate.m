//
//  GICJSElementDelegate.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/7.
//

#import "GICJSElementDelegate.h"
#import "JSValue+GICJSExtension.h"
#import "GICJSCore.h"

@implementation GICJSElementDelegate{
    NSMutableDictionary<NSString *,JSManagedValue *> *managedValueDict;
}
-(id)initWithElement:(id)element{
    self = [super init];
    _element = element;
    managedValueDict = [NSMutableDictionary dictionary];
    return self;
}


-(void)setDataContext:(JSValue *)dataContext{
    JSManagedValue * ds =  [dataContext gic_ToManagedValue:self.element];
    // 更新数据源
    [self.element setGic_DataContext:ds];
    
    // NOTE:下面代码很关键，因为采用了JSManagedValue,因此JSValue会因为JS的垃圾回收机制会自动回收掉。因此将dataContext保存到一个本身的全局变量中就不会被回收，除非本身的value被回收才会一并回收掉
    JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self.element inContext:[dataContext context]];
    selfValue[@"__dataContext__"] = dataContext;
}

-(JSValue *)dataContext{
    id ds = [self.element gic_DataContext];
    if([ds isKindOfClass:[JSManagedValue class]]){
        JSValue *jsV = [(JSManagedValue *)ds value];
        return jsV;
    }
    return nil;
}

+(JSValue *)getJSValueFrom:(id)element inContext:(JSContext *)jsContext{
    if(jsContext==nil){
        jsContext  = [GICJSCore findJSContextFromElement:element];
    }
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
    GICJSElementDelegate *v = [[GICJSElementDelegate alloc] initWithElement:element];
    jsContext[name] = v;
    selfValue = jsContext[name];
    
    NSDictionary<NSString *, GICAttributeValueConverter *> *ps = [GICElementsCache classAttributs:[element class]];
    // 初始化元素
    [selfValue invokeMethod:@"_elementInit" withArguments:@[ps.allKeys]];
    // 当元素释放的时候自动删除变量
    __weak JSContext *weakContext = jsContext;
    [[element rac_willDeallocSignal] subscribeCompleted:^{
        [weakContext evaluateScript:[NSString stringWithFormat:@"delete %@",name]];
    }];
    return selfValue;
}

- (void)_setEvent:(NSString *)eventName eventFunc:(JSValue *)eventFunc{
    managedValueDict[eventName] = [JSManagedValue managedValueWithValue:eventFunc];
    GICEvent *event = [_element gic_event_findFirstWithEventNameOrCreate:eventName];
    @weakify(self)
    [event.eventSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [(self-> managedValueDict[eventName]).value callWithArguments:nil];
    }];
}

-(id)_getAttValue:(NSString *)attName{
    GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[_element class]][attName];
    if(p && p.propertyGetter){
        id v = p.propertyGetter(_element);
        return [p valueToString:v];
    }
    return nil;
}

+(JSValue *)getSuperElement:(id)selfElement{
    id superEl = [selfElement gic_getSuperElement];
    if(superEl){
        return [GICJSElementDelegate getJSValueFrom:superEl inContext:[JSContext currentContext]];
    }
    return nil;
}

-(JSValue *)_getSuperElement{
    return [GICJSElementDelegate getSuperElement:self.element];
}

- (void)_setAttValue:(NSString *)attName newValue:(NSString *)newValue {
    GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[_element class]][attName];
    if(p){
        p.propertySetter(_element, [p convert:newValue]);
    }
}

-(NSArray *)subElements{
    NSMutableArray *mutArray = [NSMutableArray array];
    [[self.element gic_subElements] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutArray addObject:[GICJSElementDelegate getJSValueFrom:obj inContext:[JSContext currentContext]]];
    }];
    return mutArray;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"<GICJSElementValue>: elementName = %@, name = %@",[[_element class] gic_elementName],  [_element gic_ExtensionProperties].name];
}

-(void)removeFromSupeElement{
    [self.element gic_removeFromSuperElement];
}

@end
