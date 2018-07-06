//
//  UIScrollView+GICScrollView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "UIScrollView+GICScrollView.h"
#import "GICNumberConverter.h"

@implementation UIScrollView (GICScrollView)
+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"show-ver-scroll":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(UIScrollView *)target setShowsVerticalScrollIndicator:[value boolValue]];
             }],
             @"show-hor-scroll":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(UIScrollView *)target setShowsHorizontalScrollIndicator:[value boolValue]];
             }],
             };;
}
@end
