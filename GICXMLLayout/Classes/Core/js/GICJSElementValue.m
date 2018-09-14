//
//  GICJSElementValue.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import "GICJSElementValue.h"
#import "GICTapEvent.h"

#import "GICDataBinding+JSScriptExtension.h"



@implementation GICJSElementValue{
    NSMutableDictionary<NSString *,JSManagedValue *> *managedValueDict;
}
-(id)initWithElement:(id)element{
    self = [super init];
    _element = element;
    managedValueDict = [NSMutableDictionary dictionary];
    return self;
}


-(void)setDataContext:(JSValue *)dataContext{
    managedValueDict[@"dataSource"] = [JSManagedValue managedValueWithValue:dataContext];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedValueDict[@"dataSource"] withOwner:self];
    // 更新数据源
    [GICDataBinding updateDataContextFromJsValue:dataContext element:self.element];
}

-(JSValue *)dataContext{
    return managedValueDict[@"dataSource"].value;
}

+(JSValue *)getJSValueFrom:(id)element inContext:(JSContext *)jsContext{
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
    // 初始化元素
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
        return [GICJSElementValue getJSValueFrom:superEl inContext:[selfValue context]];
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
