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
    self.automaticallyManagesSubnodes = YES;
    return self;
}



-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:self.gic_displayNodes];
    return absoluteSpec;
}


@end
