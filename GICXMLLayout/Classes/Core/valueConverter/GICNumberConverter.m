//
//  GICFloatConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICNumberConverter.h"

@implementation GICNumberConverter
-(NSNumber *)convert:(NSString *)stringValue{
    checkDefualtValue(stringValue);
    return @([GICUtils numberConverter:stringValue]);
}

-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per;{
    return  @([GICUtils calcuPerValue:[from floatValue] to:[to floatValue] per:per]);
}

-(NSString *)valueToString:(NSNumber *)value{
    return [value stringValue];
}
@end
