//
//  JSValue+GICJSExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/2.
//

#import "JSValue+GICJSExtension.h"
#import "GICJSCore.h"

@implementation JSValue (GICJSExtension)
+(JSValue *)getJSValueFrom:(id)element inContext:(id)jsContext{
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
    //    GICJSElementValue *v = [[GICJSElementValue alloc] initWithElement:element];
    //    NSDictionary<NSString *, GICAttributeValueConverter *> *ps = [GICElementsCache classAttributs:[element class]];
    //    // 初始化元素
    //    [selfValue invokeMethod:@"_elementInit" withArguments:@[ps.allKeys]];
    jsContext[name] = element;
    
    
    JSValue *jsValue =  jsContext[name];
    NSDictionary<NSString *, GICAttributeValueConverter *> *ps = [GICElementsCache classAttributs:[element class]];
    // 初始化元素
    if([[jsValue invokeMethod:@"_elementInit" withArguments:@[ps.allKeys]] toBool]){
        jsValue[@"__isElement__"] = @(true);
        __weak id waakEl = element;
        jsValue[@"_setEvent"] = ^(NSString *eventName,JSValue *eventFunc){
            // 这里面的事件触发，是通过类似 onclick 来实现的
            GICEvent *event = [waakEl gic_event_findFirstWithEventNameOrCreate:eventName];
            // 解决循环引用的问题
            JSManagedValue *managedValue = [JSManagedValue managedValueWithValue:eventFunc];
            [event.eventSubject subscribeNext:^(id  _Nullable x) {
                [managedValue.value callWithArguments:nil];
            }];
        };
        
        jsValue[@"_setAttValue"] = ^(NSString *attName,NSString *newValue){
            GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[waakEl class]][attName];
            if(p){
                p.propertySetter(waakEl, [p convert:newValue]);
            }
        };
        
        jsValue[@"_getAttValue"] = ^NSString *(NSString *attName){
            GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[waakEl class]][attName];
            if(p && p.propertyGetter){
                id v = p.propertyGetter(waakEl);
                return [p valueToString:v];
            }
            return nil;
        };
        
        jsValue[@"_getSuperElement"] = ^JSValue *(){
            id superEl = [waakEl gic_getSuperElement];
            if(superEl){
                return [JSValue getJSValueFrom:superEl inContext:[JSContext currentContext]];
            }
            return nil;
        };
        
        jsValue[@"subElements"] = ^NSArray *(){
            NSMutableArray *mutArray = [NSMutableArray array];
            [[waakEl gic_subElements] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mutArray addObject:[JSValue getJSValueFrom:obj inContext:[JSContext currentContext]]];
            }];
            return mutArray;
        };
        
        jsValue[@"_dataContext"] = ^JSValue *(JSValue *dataContext){
            if([dataContext isUndefined]){
                id ds = [waakEl gic_DataContext];
                if([ds isKindOfClass:[JSManagedValue class]]){
                    JSValue *jsV = [(JSManagedValue *)ds value];
                    return jsV;
                }
            }else{
                JSManagedValue * ds =  [dataContext gic_ToManagedValue:waakEl];
                // 更新数据源
                [waakEl setGic_DataContext:ds];
                
                // NOTE:下面代码很关键，因为采用了JSManagedValue,因此JSValue会因为JS的垃圾回收机制会自动回收掉。因此将dataContext保存到一个本身的全局变量中就不会被回收，除非本身的value被回收才会一并回收掉
                JSValue *selfValue = [JSValue getJSValueFrom:waakEl inContext:[dataContext context]];
                selfValue[@"__dataContext__"] = dataContext;
            }
            return nil;
        };
        
        jsValue[@"removeFromSupeElement"] = ^(){
            [waakEl gic_removeFromSuperElement];
        };
    }
    return jsValue;
}

-(BOOL)isGICElement{
     return [self[@"__isElement__"] toBool];
}

-(JSManagedValue *)gic_ToManagedValue:(id)owner{
    //    if(owner){
    //        return [JSManagedValue managedValueWithValue:self andOwner:owner];
    //    }
    return [JSManagedValue managedValueWithValue:self];
    //
    
    //    JSManagedValue *mv = [JSManagedValue managedValueWithValue:self];
    //    if(owner){
    //         [[[JSContext currentContext] virtualMachine] addManagedReference:mv withOwner:owner];
    //    }
    //    return mv;
}
@end
