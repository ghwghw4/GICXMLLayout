//
//  UIColor+Extension.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    
    if ([stringToConvert hasPrefix:@"#"]) {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    
    if (![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    
    NSInteger r = (hex >> 16) & 0xFF;
    NSInteger g = (hex >> 8) & 0xFF;
    NSInteger b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBAHex:(UInt32)hex {
    
    NSInteger r = (hex >> 24) & 0xFF;
    NSInteger g = (hex >> 16) & 0xFF;
    NSInteger b = (hex >> 8) & 0xFF;
    NSInteger a = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

+ (UIColor *)colorAndAlphaWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBAHex:hexNum];
}

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r, g, b, a;
    
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
        default:            // We don't know how to handle this model
            return NO;
    }
    
    if (red) {
        *red = r;
    }
    
    if (green) {
        *green = g;
    }
    
    if (blue) {
        *blue = b;
    }
    
    if (alpha) {
        *alpha = a;
    }
    
    return YES;
}

- (CGFloat)red {
    
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) {
        return c[0];
    }
    
    return c[1];
}

- (CGFloat)blue {
    
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) {
        return c[0];
    }
    
    return c[2];
}

- (CGFloat)alpha {
    
    return CGColorGetAlpha(self.CGColor);
}



- (UInt32)rgbaHex {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGBA color to use rgbaHex");
    
    CGFloat r, g, b, a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
    r = MIN(MAX(self.red, 0.0f), 1.0f);
    g = MIN(MAX(self.green, 0.0f), 1.0f);
    b = MIN(MAX(self.blue, 0.0f), 1.0f);
    a = MIN(MAX(self.alpha, 0.0f), 1.0f);
    
    return (((NSInteger)roundf(r * 255)) << 24)
    | (((NSInteger)roundf(g * 255)) << 16)
    | (((NSInteger)roundf(b * 255)) <<  8)
    | (((NSInteger)roundf(a * 255))         );
}

- (NSString *)hexStringFromColorAndAlpha {
    return [NSString stringWithFormat:@"%0.8X", (int)self.rgbaHex];
}

@end
