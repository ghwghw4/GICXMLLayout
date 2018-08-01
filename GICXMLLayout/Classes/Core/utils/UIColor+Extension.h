//
//  UIColor+Extension.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorAndAlphaWithHexString:(NSString *)stringToConvert;
@end
