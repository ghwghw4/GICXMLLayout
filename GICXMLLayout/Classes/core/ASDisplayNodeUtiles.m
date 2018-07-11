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
#import "GICSizeConverter.h"
#import "CGPointConverter.h"


#import "ASDisplayNode+GICExtension.h"


@implementation ASDisplayNodeUtiles
+(NSDictionary<NSString *,GICValueConverter *> *)commonPropertyConverters{
    static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyConverts = @{
                             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 [(ASDisplayNode *)target setBackgroundColor:value];
                             }],
                             @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(id target, id value) {
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.height = ASDimensionMake([value floatValue]);
                             }],
                             @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.width = ASDimensionMake([value floatValue]);
                             }],
                             @"size":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 CGSize size = [(NSValue *)value CGSizeValue];
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.width = ASDimensionMake(size.width);
                                 node.style.height = ASDimensionMake(size.height);
                             }],
                             @"point":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 CGPoint point = [(NSValue *)value CGPointValue];
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.layoutPosition = point;
                             }],
                             @"max-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.maxWidth = ASDimensionMake([value floatValue]);
                             }],
                             @"max-height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.maxHeight = ASDimensionMake([value floatValue]);
                             }],
                             @"space-before":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.spacingBefore = [value floatValue];
                             }],
                             @"space-after":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ASDisplayNode *node =  (ASDisplayNode *)target;
                                 node.style.spacingAfter = [value floatValue];
                             }],
                             @"dock-horizal":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ((ASDisplayNode *)target).gic_ExtensionProperties.dockHorizalModel = [value integerValue];
                             }],
                             @"dock-vertical":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                 ((ASDisplayNode *)target).gic_ExtensionProperties.dockVerticalModel = [value integerValue];
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
