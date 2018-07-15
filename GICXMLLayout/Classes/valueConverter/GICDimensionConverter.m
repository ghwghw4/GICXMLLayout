//
//  GICDimensionConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICDimensionConverter.h"

@implementation GICDimensionConverter
-(NSString *)convert:(NSString *)xmlStringValue{
    ASDimension h = ASDimensionMake(xmlStringValue);
    if(ASDimensionEqualToDimension(h, ASDimensionAuto)){
        h = ASDimensionMake([xmlStringValue floatValue]);
    }
    return NSStringFromASDimension(h);
}

-(NSString *)convertAnimationValue:(NSString *)from to:(NSString *)to per:(CGFloat)per{
    ASDimension d1 = ASDimensionMake(from);
    ASDimension d2 = ASDimensionMake(to);
    ASDimension d;
    d.unit = d1.unit;
    d.value = [GICUtils calcuPerValue:d1.value to:d2.value per:per];
    return NSStringFromASDimension(d);
}
@end
