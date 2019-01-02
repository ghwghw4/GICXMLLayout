//
//  GICTextAlignmentConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICTextAlignmentConverter.h"

@implementation GICTextAlignmentConverter
-(NSNumber *)convert:(NSString *)stringValue{
    checkDefualtValue(stringValue);
    if([stringValue isEqualToString:@"0"] || [stringValue isEqualToString:@"left"]){
        return @(NSTextAlignmentLeft);
    }else if ([stringValue isEqualToString:@"1"] || [stringValue isEqualToString:@"center"]){
        return @(NSTextAlignmentCenter);
    }else if ([stringValue isEqualToString:@"2"] || [stringValue isEqualToString:@"right"]){
        return @(NSTextAlignmentRight);
    }else{
        return @(NSTextAlignmentLeft);
    }
}

-(NSString *)valueToString:(NSNumber *)value{
    return [value stringValue];
}
@end
