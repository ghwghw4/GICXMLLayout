//
//  NSObject+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "NSObject+LayoutElement.h"
#import "GICXMLLayout.h"
#import "GICStringConverter.h"
#import "NSObject+GICDataBinding.h"
#import <objc/runtime.h>

@implementation NSObject (LayoutElement)

/**
 converts 缓存

 @return <#return value description#>
 */
+ (NSMutableDictionary<NSString *,NSDictionary<NSString *,GICValueConverter *> *> *)gic_classPropertyConvertsCache {
    static NSMutableDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSMutableDictionary dictionary];
    });
    return _instance;
}

+(NSDictionary<NSString *, GICValueConverter *> *)_gic_getPropertyConverts:(Class)klass{
    if(klass == [NSObject class]){
        return nil;
    }
    
    NSString *className = NSStringFromClass(klass);
    NSDictionary<NSString *,GICValueConverter *> *value = [self.gic_classPropertyConvertsCache objectForKey:className];
    if (value) {
        return value;
    }
    
    NSMutableDictionary<NSString *, GICValueConverter *> *dict = [NSMutableDictionary dictionary];
    if([klass respondsToSelector:@selector(gic_propertySetters)]){
        [dict addEntriesFromDictionary:[klass performSelector:@selector(gic_propertySetters)]];
    }
    [dict addEntriesFromDictionary:[NSObject _gic_getPropertyConverts:class_getSuperclass(klass)]];
    
    // 保存到缓存中
    [self.gic_classPropertyConvertsCache setValue:dict forKey:className];
    return dict;
}




+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyConverts = @{
                             @"name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 [target setValue:value forKey:@"gic_Name"];
                             }],
                             @"data-model":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 [target setGic_dataModelKey:value];
                             }],
                             };
    });
    return propertyConverts;
}


-(void)parseElement:(GDataXMLElement *)element{
    [self parseAttributes:[self convertAttributes:element.attributes]];
    
    // 解析子元素
    if([self respondsToSelector:@selector(gic_parseSubElements:)]){
        NSArray *children = element.children;
        if(children.count>0)
            [(id)self gic_parseSubElements:element.children];
    }
    
    if([self respondsToSelector:@selector(gic_elementParseCompelte)]){
        [self performSelector:@selector(gic_elementParseCompelte)];
    }
    
}

-(NSDictionary *)convertAttributes:(NSArray<GDataXMLNode *> *)atts{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [atts enumerateObjectsUsingBlock:^(GDataXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict setValue:[obj stringValue] forKey:[obj name]];
    }];
    return dict;
}

// 解析属性
-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    NSDictionary *ps = [NSObject _gic_getPropertyConverts:[self class]];
    for(NSString *key in attributeDict.allKeys){
        NSString *value = [attributeDict objectForKey:key];
        GICValueConverter *converter = [ps objectForKey:key];
        if([value hasPrefix:@"{{"] && [value hasSuffix:@"}}"]){
            NSString *expression = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{} "]];
            GICDataBinding *binding = [GICDataBinding createBindingFromExpression:expression];
            binding.valueConverter = converter;
            binding.target = self;
            binding.attributeName = key;
            [self.gic_Bindings addObject:binding];
            continue;
        }
        if(converter){
            converter.propertySetter(self, [converter convert:value]);
        }
    }
}


@end
