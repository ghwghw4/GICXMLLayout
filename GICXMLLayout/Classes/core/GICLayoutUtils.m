//
//  GICLayoutUtils.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/12.
//

#import "GICLayoutUtils.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICStringConverter.h"
#import "GICStringConverter.h"
#import "GICSizeConverter.h"
#import "CGPointConverter.h"
#import "GICElementLayoutStyleProtocl.h"

@implementation GICLayoutUtils
+(NSDictionary<NSString *,GICValueConverter *> *)commonPropertyConverters{
    return @{
             @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(id target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.height = ASDimensionMake([value floatValue]);
             }],
             @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.width = ASDimensionMake([value floatValue]);
             }],
             @"size":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGSize size = [(NSValue *)value CGSizeValue];
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.width = ASDimensionMake(size.width);
                 node.style.height = ASDimensionMake(size.height);
             }],
             @"position":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGPoint point = [(NSValue *)value CGPointValue];
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.layoutPosition = point;
             }],
             @"max-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.maxWidth = ASDimensionMake([value floatValue]);
             }],
             @"max-height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.maxHeight = ASDimensionMake([value floatValue]);
             }],
             @"space-before":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.spacingBefore = [value floatValue];
             }],
             @"space-after":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.spacingAfter = [value floatValue];
             }],
             @"flex-grow":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.flexGrow = [value integerValue];
             }],
             @"flex-shrink":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 id<GICElementLayoutStyleProtocol> node =  (id<GICElementLayoutStyleProtocol>)target;
                 node.style.flexShrink = [value integerValue];
             }],
//             @"corner-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 //                             ((UIView *)target).layer.cornerRadius = [value floatValue];
//                 //                             ((UIView *)target).layer.masksToBounds = YES;
//             }],
//             @"boder-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 //                             ((UIView *)target).layer.borderColor = [(UIColor *)value CGColor];
//             }],
//             @"border-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 //                             ((UIView *)target).layer.borderWidth = [value floatValue];
//             }],
             };
}
@end
