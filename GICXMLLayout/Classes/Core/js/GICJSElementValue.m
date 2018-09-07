//
//  GICJSElementValue.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import "GICJSElementValue.h"

@implementation GICJSElementValue
-(id)initWithElement:(id)element{
    self = [super init];
    _element = element;
    return self;
}

+(void)creatValueFrom:(id)element toContext:(JSContext *)jsContext{
    NSString *name = [element gic_ExtensionProperties].name;
    if(!name){
        // 随机生成一个名称
        int  r = arc4random() % 10000;
        name = [NSString stringWithFormat:@"_auto%.4d_%.0f",r,[[NSDate date] timeIntervalSince1970]*1000];
        [element gic_ExtensionProperties].name = name;
    }
    
    if(!jsContext[name].isUndefined){//说明已经存在
        return;
    }
    GICJSElementValue *v = [[GICJSElementValue alloc] initWithElement:element];
    jsContext[name] = v;
    
    NSDictionary<NSString *, GICAttributeValueConverter *> *ps = [GICElementsCache classAttributs:[element class]];
    NSString *attStrings = [ps.allKeys componentsJoinedByString:@","];
    [jsContext evaluateScript:[NSString stringWithFormat:@"GIC._addGetterSetter(%@,\"%@\");",name,attStrings]];
}

-(id)getAttValue:(NSString *)attName{
    GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[_element class]][attName];
    if(p && p.propertyGetter){
        id v = p.propertyGetter(_element);
        return [p valueToString:v];
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
