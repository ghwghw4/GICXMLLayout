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
#import "GICDataBinding.h"
#import "NSObject+GICDataBinding.h"

@implementation UIView (LayoutView)

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UIView *)target setBackgroundColor:value];
                         }],
                         @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_Height = [value floatValue];
                         }],
                         @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_Width = [value floatValue];
                         }],
                         @"margin":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [target setValue:value forKey:@"gic_margin"];
                         }],
                         @"name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [target setValue:value forKey:@"gic_Name"];
                         }],
                         @"margin-top":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginTop = [value floatValue];
                         }],
                         @"margin-left":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginLeft = [value floatValue];
                         }],
                         @"margin-right":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginRight = [value floatValue];
                         }],
                         @"margin-bottom":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_marginBottom = [value floatValue];
                         }],
                         @"data-model":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UIView *)target setGic_dataModelKey:value];
                         }],
                         };
}

-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    NSMutableDictionary *ps = [NSMutableDictionary dictionaryWithDictionary:propertyConverts];
    if([[self class] respondsToSelector:@selector(gic_propertySetters)]){
        [ps addEntriesFromDictionary:[[self class] performSelector:@selector(gic_propertySetters)]];
    }
    for(NSString *key in attributeDict.allKeys){
        NSString *value = [attributeDict objectForKey:key];
        GICValueConverter *converter = [ps objectForKey:key];
        if([value hasPrefix:@"{{"] && [value hasSuffix:@"}}"]){
            NSString *propertyName = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{} "]];
            GICDataBinding *binding = [GICDataBinding new];
            binding.valueConverter = converter;
            binding.dataSourceValueKey = propertyName;
            binding.target = self;
            [self.gic_Bindings addObject:binding];
            continue;
        }
        if(converter){
            converter.propertySetter(self, [converter convert:value]);
        }
    }
}
@end
