//
//  GICFloatConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICNumberConverter.h"

@implementation GICNumberConverter
-(NSNumber *)convert:(NSString *)xmlStringValue{
    return @([GICUtils numberConverter:xmlStringValue]);
}

-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per;{
    return  @([GICUtils calcuPerValue:[from floatValue] to:[to floatValue] per:per]);
}
@end
