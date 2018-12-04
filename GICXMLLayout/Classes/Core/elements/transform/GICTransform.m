//
//  GICTransform.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/3.
//

#import "GICTransform.h"

@implementation GICTransform
-(CATransform3D)makeTransform:(CGRect)frame{
    NSAssert(NO, @"由子类实现");
    return CATransform3DIdentity;
}

#pragma mark GICDisplayProtocol
-(void)gic_setNeedDisplay{
    [self.gic_getSuperElement gic_setNeedDisplay];
}
@end
