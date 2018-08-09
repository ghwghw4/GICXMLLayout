//
//  GICDimensionConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICDimensionConverter.h"

@implementation GICDimensionConverter
-(NSValue *)convert:(NSString *)stringValue{
    ASDimension h = ASDimensionMake(stringValue);
    if(ASDimensionEqualToDimension(h, ASDimensionAuto)){
        h = ASDimensionMake([stringValue floatValue]);
    }
    return [NSValue valueWithASDimension:h];
}

-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per{
    ASDimension d1 = [from ASDimension];
    ASDimension d2 = [to ASDimension];
    return [NSValue valueWithASDimension:[GICDimensionConverter convertAnimationValue:d1 to:d2 per:per]];
}

+(ASDimension)convertAnimationValue:(ASDimension)from to:(ASDimension)to per:(CGFloat)per{
    NSAssert(from.unit == to.unit, @"to 和 from 的单位不一致");
    ASDimension d;
    d.unit = from.unit;
    d.value = [GICUtils calcuPerValue:from.value to:to.value per:per];
    return d;
}
@end
