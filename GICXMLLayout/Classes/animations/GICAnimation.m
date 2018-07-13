//
//  GICAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICAnimation.h"

@implementation GICAnimation
-(id)init{
    self  = [super init];
    animation = [self createAnimation];
    return self;
}

-(POPAnimation *)createAnimation{
    return nil;
}
@end
