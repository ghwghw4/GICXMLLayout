//
//  GICUtils.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import <Foundation/Foundation.h>

@interface GICUtils : NSObject
+(CGFloat)numberConverter:(NSString *)stringValue;
+(UIColor *)colorConverter:(NSString *)stringValue;

+(NSString *)regularMatchFirst:(NSString *)str pattern:(NSString *)pattern;

+ (NSString *)uuidString;

+(BOOL)isNull:(id)obj;

+(void)mainThreadExcu:(os_block_t)block;

+(CGFloat)calcuPerValue:(CGFloat)from to:(CGFloat)to per:(CGFloat)per;
@end
