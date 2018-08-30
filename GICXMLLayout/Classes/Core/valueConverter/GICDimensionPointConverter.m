//
//  GICDimensionPointConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import "GICDimensionPointConverter.h"
#import "GICDimensionConverter.h"

ASDimensionPoint ASDimensionPointMakeFromString(NSString *str){
    NSArray *strs = [str componentsSeparatedByString:@" "];
    ASDimensionPoint point = {};
    if(strs.count==1){
        point = ASDimensionPointMake(ASDimensionMakeFromString(strs[0]), ASDimensionMakeFromString(strs[0]));
    }else if (strs.count==2){
        point = ASDimensionPointMake(ASDimensionMakeFromString(strs[0]), ASDimensionMakeFromString(strs[1]));
    }
    return point;
}

@implementation GICDimensionPointConverter
-(NSValue *)convert:(NSString *)stringValue{
    return [NSValue valueWithASDimensionPoint:ASDimensionPointMakeFromString(stringValue)];
}

-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per{
    ASDimensionPoint d1 = [from ASDimensionPoint];
    ASDimensionPoint d2 = [to ASDimensionPoint];
    ASDimensionPoint size = ASDimensionPointMake([GICDimensionConverter convertAnimationValue:d1.x to:d2.x per:per], [GICDimensionConverter convertAnimationValue:d1.y to:d2.y per:per]);
    return [NSValue valueWithASDimensionPoint:size];
}

-(NSString *)valueToString:(NSValue *)value{
    ASDimensionPoint d = [value ASDimensionPoint];
    return [NSString stringWithFormat:@"%@ %@",NSStringFromASDimension(d.x),NSStringFromASDimension(d.y)];
}
@end
