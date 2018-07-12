//
//  GICView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/12.
//

#import "GICView.h"

@implementation GICView

+(NSString *)gic_elementName{
    return @"view";
}

-(id)init{
    self =[super init];
    self.automaticallyManagesSubnodes = YES;
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    return [self gic_layoutSpecThatFits:constrainedSize];
}
@end
