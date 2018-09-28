//
//  GICListHeader.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/28.
//

#import "GICListHeader.h"

@implementation GICListHeader
+(NSString *)gic_elementName{
    return @"header";
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    self.automaticallyManagesSubnodes = YES;
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:self.gic_displayNodes];
    return absoluteSpec;
}
@end
