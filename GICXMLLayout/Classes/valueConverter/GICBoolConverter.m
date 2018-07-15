//
//  GICBoolConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICBoolConverter.h"

@implementation GICBoolConverter
-(NSNumber *)convert:(NSString *)xmlStringValue{
    if([xmlStringValue isEqualToString:@"true"]){
        return @(YES);
    }else if ([xmlStringValue isEqualToString:@"false"]){
        return @(NO);
    }
    return @([GICUtils numberConverter:xmlStringValue]);
}

-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per{
    return @(per==1);
}
@end
