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
#import "NSObject+GICDirective.h"
#import "NSObject+GICTemplate.h"
#import "GICTemplateRef.h"

@implementation NSObject (LayoutElement)

+(NSString *)gic_elementName{
    return nil;
}

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
    if(!klass){
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

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    for(GDataXMLElement *child in children){
        id childElement = [GICXMLLayout createElement:child];
        if(childElement == nil)
            continue;
        [self gic_addSubElement:childElement];
    }
}

-(void)gic_addSubElement:(NSObject *)subElement{
    if ([subElement isKindOfClass:[GICDirective class]]){//如果是指令，那么交给指令自己执行
        [self gic_addDirective:(GICDirective *)subElement];
    }else if ([subElement isKindOfClass:[GICTemplates class]]){
        self.gic_templates = (GICTemplates *)subElement;
        // 将模板加入临时上下文中
        [[[GICXMLParserContext currentInstance] currentTemplates] addEntriesFromDictionary:self.gic_templates.templats];
    }else if ([subElement isKindOfClass:[GICTemplateRef class]]){
        // 模板引用
        GICTemplateRef *tr = (GICTemplateRef *)subElement;
        tr.gic_DataContenxt = self.gic_DataContenxt;
        [self gic_addSubElement:[tr parseTemplateFromTarget:self]];
    }
}


-(void)parseElement:(GDataXMLElement *)element{
    [self parseAttributes:[self convertAttributes:element.attributes]];
    
    // 解析子元素
    if([self respondsToSelector:@selector(gic_parseSubElements:)]){
        NSArray *children = element.children;
        if(children.count>0 && [children[0] isKindOfClass:[GDataXMLElement class]]){// 添加后面这个判断主要是为了解决某些标签在有结束标签的时候添加了换行，有可能会出现解析出错。
            // 检查是否支持单个子元素
            if([self respondsToSelector:@selector(gic_parseOnlyOneSubElement)] && [(id)self gic_parseOnlyOneSubElement]){
                NSAssert1(children.count <= 1, @"%@只支持单个子元素", element.name);
                if(children.count!=1){
                    return;
                }
            }
            [(id)self gic_parseSubElements:element.children];
        }
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
            [self gic_addBinding:binding];
            continue;
        }
        if(converter){
            converter.propertySetter(self, [converter convert:value]);
        }
    }
}


@end
