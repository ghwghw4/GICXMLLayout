//
//  GICRotateAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/23.
//

#import "GICRotateAnimation.h"

@implementation GICRotateAnimation
+(NSString *)gic_elementName{
    return @"anim-rotate";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"from":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICRotateAnimation *)target).fromValue = value;
             }],
             @"to":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICRotateAnimation *)target).toValue = value;
             }],
             };;
}

-(id)init{
    self = [super init];
    numberConverter = [GICNumberConverter new];
    return self;
}

-(CATransform3D)makeTransformWithPercent:(CGFloat)per{
    CGFloat value = [[self->numberConverter convertAnimationValue:self.fromValue to:self.toValue per:per] floatValue];
//    return CGAffineTransformMakeRotation((value / 180) * M_PI);
    return CATransform3DMakeRotation((value / 180) * M_PI, 0, 0, 1);
}
@end
