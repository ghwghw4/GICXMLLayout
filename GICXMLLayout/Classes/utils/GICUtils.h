//
//  GICUtils.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import <Foundation/Foundation.h>

@interface GICUtils : NSObject
+(CGFloat)numberConverter:(NSString *)stringValue;

+(NSString *)regularMatchFirst:(NSString *)str pattern:(NSString *)pattern;

+ (NSString *)uuidString;
@end
