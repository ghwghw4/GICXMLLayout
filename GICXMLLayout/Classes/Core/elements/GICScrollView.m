//
//  GICScrollView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICScrollView.h"
#import "GICPanel.h"
#import "GICBoolConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"

@implementation GICScrollView
+(NSString *)gic_elementName{
    return @"scroll-view";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICScrollView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsVerticalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICScrollView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsHorizontalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"content-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICScrollView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setValue:value forKey:@"contentInset"];
                 }];
             }],
             
             @"content-inset-behavior":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 if (@available(iOS 11.0, *)) {
                     [(GICScrollView *)target gic_safeView:^(UIView *view) {
                         [(UIScrollView *)view setContentInsetAdjustmentBehavior:[value integerValue]];
                     }];
                 }
             }],
             };;
}

-(id)init{
    self =[super init];
    self.automaticallyManagesContentSize = YES;
    self.automaticallyManagesSubnodes = YES;
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *temp = [ASStackLayoutSpec verticalStackLayoutSpec];
    temp.children = self.gic_displayNodes;
    return temp;
}
@end
