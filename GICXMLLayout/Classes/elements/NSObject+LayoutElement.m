//
//  NSObject+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "NSObject+LayoutElement.h"
#import "GICXMLLayout.h"

@implementation NSObject (LayoutElement)
-(void)parseElement:(GDataXMLElement *)element{
    [self parseAttributes:[self convertAttributes:element.attributes]];
    
    // 解析子元素
    if([self respondsToSelector:@selector(gic_parseSubViews:)]){
        NSArray *children = element.children;
        if(children.count>0)
            [(id)self gic_parseSubViews:element.children];
    }
    //    for(GDataXMLElement *child in element.children){
    //        UIView *childView =[GICXMLLayout createElement:child];
    //        if(childView){
    //           [self addSubview:childView];
    //        }
    //    }
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

-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    NSMutableDictionary *ps = [NSMutableDictionary dictionary];
    if([[self class] respondsToSelector:@selector(gic_propertySetters)]){
        [ps addEntriesFromDictionary:[[self class] performSelector:@selector(gic_propertySetters)]];
    }
    for(NSString *key in attributeDict.allKeys){
        GICValueConverter *converter = [ps objectForKey:key];
        if(converter){
            converter.propertySetter(self, [converter convert:[attributeDict objectForKey:key]]);
        }
    }
}
@end
