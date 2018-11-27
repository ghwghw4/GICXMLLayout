//
//  GICScaleAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/23.
//

#import "GICScaleAnimation.h"

@implementation GICScaleAnimation
+(NSString *)gic_elementName{
    return @"anim-scale";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"from":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICScaleAnimation *)target).fromValue = value;
             }],
             @"to":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICScaleAnimation *)target).toValue = value;
             }],
             };;
}

-(id)init{
    self = [super init];
    sizeConverter = [GICSizeConverter new];
    return self;
}

-(CATransform3D)makeTransformWithPercent:(CGFloat)per{
    CGSize value = [[self->sizeConverter convertAnimationValue:self.fromValue to:self.toValue per:per] CGSizeValue];
//    return CGAffineTransformMakeScale(MAX(value.width, 0), MAX(value.height, 0));
    return CATransform3DMakeScale(MAX(value.width, 0), MAX(value.height, 0), 1);
}
@end
