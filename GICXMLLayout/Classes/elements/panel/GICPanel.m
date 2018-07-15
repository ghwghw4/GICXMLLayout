//
//  GICPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICPanel.h"
#import "GICXMLLayout.h"
#import "GICDirective.h"

@implementation GICPanel
+(NSString *)gic_elementName{
    return @"panel";
}

-(id)init{
    self = [super init];
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:self.subnodes];
    return absoluteSpec;
}
@end
