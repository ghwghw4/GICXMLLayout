//
//  GICBoolConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICBoolConverter.h"

@implementation GICBoolConverter
-(NSNumber *)convert:(NSString *)stringValue{
    if([stringValue isEqualToString:@"true"]){
        return @(YES);
    }else if ([stringValue isEqualToString:@"false"]){
        return @(NO);
    }
    return @([GICUtils numberConverter:stringValue]);
}

-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per{
    return @(per==1);
}
@end
