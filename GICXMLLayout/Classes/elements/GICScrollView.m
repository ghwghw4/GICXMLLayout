//
//  GICScrollView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICScrollView.h"
#import <Masonry/Masonry.h>
#import "UIView+GICExtension.h"
#import "GICPanel.h"
#import "GICBoolConverter.h"

@implementation GICScrollView
+(NSString *)gic_elementName{
    return @"scroll-view";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [[(GICScrollView *)target view] setShowsVerticalScrollIndicator:[value boolValue]];
             }],
             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [[(GICScrollView *)target view] setShowsHorizontalScrollIndicator:[value boolValue]];
             }],
             };;
}

-(id)init{
    self =[super init];
    self.automaticallyManagesSubnodes = YES;
    self.automaticallyManagesContentSize = YES;
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    stackLayoutSpec.children = self.subnodes;
    return stackLayoutSpec;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
