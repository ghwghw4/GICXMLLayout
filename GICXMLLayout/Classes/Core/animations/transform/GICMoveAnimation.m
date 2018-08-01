//
//  GICMoveAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICMoveAnimation.h"
#import "CGPointConverter.h"

@implementation GICMoveAnimation
+(NSString *)gic_elementName{
    return @"anim-move";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"from":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICMoveAnimation *)target).fromValue = value;
             }],
             @"to":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICMoveAnimation *)target).toValue = value;
             }],
             };;
}

-(id)init{
    self = [super init];
    pointConverter = [CGPointConverter new];
    return self;
}

-(CGAffineTransform)makeTransformWithPercent:(CGFloat)per{
    CGPoint value = [[self->pointConverter convertAnimationValue:self.fromValue to:self.toValue per:per] CGPointValue];
    return CGAffineTransformMakeTranslation(value.x, value.y);
}
@end
