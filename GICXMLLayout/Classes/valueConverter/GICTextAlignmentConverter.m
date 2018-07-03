//
//  GICTextAlignmentConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICTextAlignmentConverter.h"

@implementation GICTextAlignmentConverter
-(NSNumber *)convert:(NSString *)xmlStringValue{
    if([xmlStringValue isEqualToString:@"0"] || [xmlStringValue isEqualToString:@"left"]){
        return @(NSTextAlignmentLeft);
    }else if ([xmlStringValue isEqualToString:@"1"] || [xmlStringValue isEqualToString:@"center"]){
        return @(NSTextAlignmentCenter);
    }else if ([xmlStringValue isEqualToString:@"2"] || [xmlStringValue isEqualToString:@"right"]){
        return @(NSTextAlignmentRight);
    }else{
        return @(NSTextAlignmentLeft);
    }
}
@end
