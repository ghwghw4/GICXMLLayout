//
//  ASDisplayNodeUtiles.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNodeUtiles.h"
#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICStringConverter.h"
#import "GICStringConverter.h"


@implementation ASDisplayNodeUtiles
+(NSDictionary<NSString *,GICValueConverter *> *)commonPropertyConverters{
    static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyConverts = @{
                             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 [(ASDisplayNode *)target setBackgroundColor:value];
                             }],
                             @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.height = [value floatValue];
                             }],
                             @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.width = [value floatValue];
                             }],
                             @"margin":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             [((UIView *)target).gic_ExtensionProperties setValue:value forKey:@"margin"];
                             }],
                             @"margin-top":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.marginTop = [value floatValue];
                             }],
                             @"margin-left":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.marginLeft = [value floatValue];
                             }],
                             @"margin-right":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.marginRight = [value floatValue];
                             }],
                             @"margin-bottom":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.marginBottom = [value floatValue];
                             }],
                             @"dock-horizal":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).gic_ExtensionProperties.dockHorizalModel = [value integerValue];
                             }],
                             @"dock-vertical":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                              ((UIView *)target).gic_ExtensionProperties.dockVerticalModel = [value integerValue];
                             }],
                             @"corner-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).layer.cornerRadius = [value floatValue];
                                 //                             ((UIView *)target).layer.masksToBounds = YES;
                             }],
                             @"boder-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).layer.borderColor = [(UIColor *)value CGColor];
                             }],
                             @"border-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 //                             ((UIView *)target).layer.borderWidth = [value floatValue];
                             }],
                             };
    });
    return propertyConverts;
}
@end
