//
//  GICStackPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICStackPanel.h"
#import "GICBoolConverter.h"
#import "GICNumberConverter.h"

@implementation GICStackPanel
+(NSString *)gic_elementName{
    return @"stack-panel";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"is-horizon":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICStackPanel *)target)->stackLayoutSpec.direction = [value boolValue]?ASStackLayoutDirectionHorizontal:ASStackLayoutDirectionVertical;
             }],
             @"justify-content":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICStackPanel *)target)->stackLayoutSpec.justifyContent = [value integerValue];
             }],
             @"align-items":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICStackPanel *)target)->stackLayoutSpec.alignItems = [value integerValue];
             }],
             @"space":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICStackPanel *)target)->stackLayoutSpec.spacing = [value floatValue];
             }],
             };
}

-(id)init{
    self = [super init];
    stackLayoutSpec = [[ASStackLayoutSpec alloc] init];
    stackLayoutSpec.direction = ASStackLayoutDirectionVertical;
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    stackLayoutSpec.children = self.subnodes;
    return stackLayoutSpec;
}
@end
