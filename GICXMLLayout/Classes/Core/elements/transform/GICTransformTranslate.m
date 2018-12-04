//
//  GICTransformTranslate.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/3.
//

#import "GICTransformTranslate.h"
#import "GICNumberConverter.h"

@implementation GICTransformTranslate
+(NSString *)gic_elementName{
    return @"translate";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"x":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformTranslate *)target).x = [value floatValue];
             }],
             @"y":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformTranslate *)target).y = [value floatValue];
             }],
             @"z":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformTranslate *)target).z = [value floatValue];
             }],
             };;
}

-(void)setX:(CGFloat)x{
    _x = x;
    [self gic_setNeedDisplay];
}

-(void)setY:(CGFloat)y{
    _y = y;
    [self gic_setNeedDisplay];
}

-(void)setZ:(CGFloat)z{
    _z = z;
    [self gic_setNeedDisplay];
}

-(CATransform3D)makeTransform{
    return CATransform3DMakeTranslation(self.x, self.y, self.z);
}
@end
