//
//  UIView+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "UIView+LayoutView.h"
#import "UIColor+Extension.h"
#import "GDataXMLNode.h"
#import "GICXMLLayout.h"
#import "UIView+GICExtension.h"
#import <objc/runtime.h>

#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICStringConverter.h"


@implementation UIView (LayoutView)

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                             [view setBackgroundColor:value];
                         }],
                         @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                             view.gic_Height = [value floatValue];
                         }],
                         @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                             view.gic_Width = [value floatValue];
                         }],
                         @"margin":[[GICEdgeConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                             [view setValue:value forKey:@"gic_margin"];
                         }],
                         @"name":[[GICStringConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                             [view setValue:value forKey:@"gic_Name"];
                         }],
                         };
}






-(void)parseElement:(GDataXMLElement *)element{
    [self parseAttributes:[self convertAttributes:element.attributes]];
    for(GDataXMLElement *child in element.children){
        UIView *childView =[GICXMLLayout createElement:child];
        if(childView){
           [self addSubview:childView];
        }
    }
    if([self respondsToSelector:@selector(elementParseCompelte)]){
        [self performSelector:@selector(elementParseCompelte)];
    }
}

-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    NSMutableDictionary *ps = [NSMutableDictionary dictionaryWithDictionary:propertyConverts];
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


-(NSDictionary *)convertAttributes:(NSArray<GDataXMLNode *> *)atts{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [atts enumerateObjectsUsingBlock:^(GDataXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict setValue:[obj stringValue] forKey:[obj name]];
    }];
    return dict;
}
@end
