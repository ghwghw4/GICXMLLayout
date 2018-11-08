//
//  GICUtils.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICUtils.h"
#import "UIColor+Extension.h"

@implementation GICUtils
static NSDictionary<NSString *,UIColor *> *colorsMap;
+(void)initialize{
    colorsMap = @{
                 @"red":[UIColor redColor],
                 @"white":[UIColor whiteColor],
                 @"black":[UIColor blackColor],
                 @"blue":[UIColor blueColor],
                 @"dark-gray":[UIColor darkGrayColor],
                 @"light-gray":[UIColor lightGrayColor],
                 @"gray":[UIColor grayColor],
                 @"green":[UIColor greenColor],
                 @"cyan":[UIColor cyanColor],
                 @"yellow":[UIColor yellowColor],
                 @"magenta":[UIColor magentaColor],
                 @"orange":[UIColor orangeColor],
                 @"purple":[UIColor purpleColor],
                 @"brown":[UIColor brownColor],
                 @"clear":[UIColor clearColor],
                 };
}

+(CGFloat)numberConverter:(NSString *)stringValue{
//    if([stringValue.lowercaseString isEqualToString:@"auto"]){
//        return NumberAuto;
//    }
    return [stringValue floatValue];
}

+(UIColor *)colorConverter:(NSString *)stringValue{
    UIColor *temp = [colorsMap objectForKey:stringValue.lowercaseString];
    if(temp){
        return temp;
    }
    if(stringValue.length == 8)
        return [UIColor colorAndAlphaWithHexString:stringValue];
    
    return [UIColor colorWithHexString:stringValue];
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

+(void)mainThreadExcu:(os_block_t)block{
    dispatch_async(dispatch_get_main_queue(), block);
}

+(CGFloat)calcuPerValue:(CGFloat)from to:(CGFloat)to per:(CGFloat)per{
    CGFloat p = MAX(0, per);
    p = MIN(1, p);
    return from +(to - from)*p;
}
@end
