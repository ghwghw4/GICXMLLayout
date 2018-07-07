//
//  GICUtils.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICUtils.h"

@implementation GICUtils
+(CGFloat)numberConverter:(NSString *)stringValue{
//    if([stringValue.lowercaseString isEqualToString:@"auto"]){
//        return NumberAuto;
//    }
    return [stringValue floatValue];
}

+(NSString *)regularMatchFirst:(NSString *)str pattern:(NSString *)pattern{
    NSRange range = [str rangeOfString:pattern options:NSRegularExpressionSearch];
    if(range.location != NSNotFound)
        return  [str substringWithRange:range];
    else
        return nil;
    return nil;
}

+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+(BOOL)isNull:(id)obj{
    if(!obj || [obj isKindOfClass:[NSNull class]])
        return YES;
    return NO;
}
@end
