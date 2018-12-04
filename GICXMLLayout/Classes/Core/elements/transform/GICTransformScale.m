//
//  GICTransformScale.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/3.
//

#import "GICTransformScale.h"
#import "GICNumberConverter.h"

@implementation GICTransformScale
+(NSString *)gic_elementName{
    return @"scale";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"x":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformScale *)target).x = [value floatValue];
             }],
             @"y":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformScale *)target).y = [value floatValue];
             }],
             @"z":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformScale *)target).z = [value floatValue];
             }],
             };;
}

-(id)init{
    self = [super init];
    _x = 1;
    _y = 1;
    _z = 1;
    return self;
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
    return CATransform3DMakeScale(self.x, self.y, self.z);
}
@end
