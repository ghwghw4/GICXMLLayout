//
//  GICTransformRotate.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/3.
//

#import "GICTransformRotate.h"
#import "GICNumberConverter.h"

@implementation GICTransformRotate
+(NSString *)gic_elementName{
    return @"rotate";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"z":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformRotate *)target).z = [value floatValue];
             }],
             @"x":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformRotate *)target).x = [value floatValue];
             }],
             @"y":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICTransformRotate *)target).y = [value floatValue];
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
    CATransform3D t = CATransform3DIdentity;
    if(self.x != 0){
        
        t = CATransform3DConcat(t, CATransform3DMakeRotation((self.x / 180) * M_PI  , 1, 0, 0));
    }
    
    if(self.y != 0){
        t = CATransform3DConcat(t, CATransform3DMakeRotation((self.y / 180) * M_PI, 0, 1, 0));
    }
    
    if(self.z != 0){
        t = CATransform3DConcat(t, CATransform3DMakeRotation((self.z / 180) * M_PI, 0, 0, 1));
    }
    
    return t;
}
@end
