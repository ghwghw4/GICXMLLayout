//
//  GICColorConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICColorConverter.h"
#import "UIColor+Extension.h"

@implementation GICColorConverter
-(UIColor *)convert:(NSString *)xmlStringValue{
    return [GICUtils colorConverter:xmlStringValue];
}

-(UIColor *)convertAnimationValue:(UIColor *)from to:(UIColor *)to per:(CGFloat)per{
    CGFloat red1;
    CGFloat blue1;
    CGFloat green1;
    CGFloat alpha1;
    [from getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2;
    CGFloat blue2;
    CGFloat green2;
    CGFloat alpha2;
    [to getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    return [UIColor colorWithRed:[GICUtils calcuPerValue:red1 to:red2 per:per] green:[GICUtils calcuPerValue:green1 to:green2 per:per] blue:[GICUtils calcuPerValue:blue1 to:blue2 per:per] alpha:[GICUtils calcuPerValue:alpha1 to:alpha2 per:per]];
}
@end
