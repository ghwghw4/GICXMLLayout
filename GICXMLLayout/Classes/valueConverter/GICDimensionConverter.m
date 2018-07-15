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
@end
