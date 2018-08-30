//
//  GICLayoutSizeConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import "GICLayoutSizeConverter.h"
#import "GICDimensionConverter.h"

ASLayoutSize ASLayoutSizeMakeFromString(NSString *str){
    NSArray *strs = [str componentsSeparatedByString:@" "];
    ASLayoutSize size = ASLayoutSizeAuto;
    if(strs.count==1){
        size = ASLayoutSizeMake(ASDimensionMakeFromString(strs[0]), ASDimensionMakeFromString(strs[0]));
    }else if (strs.count==2){
        size = ASLayoutSizeMake(ASDimensionMakeFromString(strs[0]), ASDimensionMakeFromString(strs[1]));
    }
    return size;
}

@implementation GICLayoutSizeConverter
-(NSValue *)convert:(NSString *)stringValue{
    return [NSValue valueWithASLayoutSize:ASLayoutSizeMakeFromString(stringValue)];
}

-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per{
    ASLayoutSize d1 = [from ASLayoutSize];
    ASLayoutSize d2 = [to ASLayoutSize];
    ASLayoutSize size = ASLayoutSizeMake([GICDimensionConverter convertAnimationValue:d1.width to:d2.width per:per], [GICDimensionConverter convertAnimationValue:d1.height to:d2.height per:per]);
    return [NSValue valueWithASLayoutSize:size];
}

-(NSString *)valueToString:(NSValue *)value{
    ASLayoutSize d = [value ASLayoutSize];
    return [NSString stringWithFormat:@"%@ %@",NSStringFromASDimension(d.width),NSStringFromASDimension(d.height)];
}
@end
