//
//  NSObject+GICAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "NSObject+GICAnimation.h"

@implementation NSObject (GICAnimation)
-(void)gic_addAnimation:(GICAnimation *)animtaion{
    [self gic_addBehavior:animtaion];
}
@end
