//
//  GICColorConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICColorConverter.h"
#import "UIColor+Extension.h"

@implementation GICColorConverter
//@property(class, nonatomic, readonly) UIColor *blackColor;      // 0.0 white
//@property(class, nonatomic, readonly) UIColor *darkGrayColor;   // 0.333 white
//@property(class, nonatomic, readonly) UIColor *lightGrayColor;  // 0.667 white
//@property(class, nonatomic, readonly) UIColor *whiteColor;      // 1.0 white
//@property(class, nonatomic, readonly) UIColor *grayColor;       // 0.5 white
//@property(class, nonatomic, readonly) UIColor *redColor;        // 1.0, 0.0, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *greenColor;      // 0.0, 1.0, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *blueColor;       // 0.0, 0.0, 1.0 RGB
//@property(class, nonatomic, readonly) UIColor *cyanColor;       // 0.0, 1.0, 1.0 RGB
//@property(class, nonatomic, readonly) UIColor *yellowColor;     // 1.0, 1.0, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *magentaColor;    // 1.0, 0.0, 1.0 RGB
//@property(class, nonatomic, readonly) UIColor *orangeColor;     // 1.0, 0.5, 0.0 RGB
//@property(class, nonatomic, readonly) UIColor *purpleColor;     // 0.5, 0.0, 0.5 RGB
//@property(class, nonatomic, readonly) UIColor *brownColor;      // 0.6, 0.4, 0.2 RGB
//@property(class, nonatomic, readonly) UIColor *clearColor;      // 0.0 white, 0.0 alpha

static NSDictionary<NSString *,UIColor *> *colorMap;
+(void)initialize{
    colorMap = @{
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


-(UIColor *)convert:(NSString *)xmlStringValue{
    UIColor *temp = [colorMap objectForKey:xmlStringValue.lowercaseString];
    if(temp){
        return temp;
    }
    return [UIColor colorWithHexString:xmlStringValue];
}

-(void)setProperty:(UIView *)view withXMLStringValue:(NSString *)xmlStringValue{
    [view setBackgroundColor:[self convert:xmlStringValue]];
}
@end
