//
//  GICView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/12.
//

#import "GICView.h"

@implementation GICView
//+ (UIColor *)randomColor
//{
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//}

+ (void)drawRect:(CGRect)bounds withParameters:(NSDictionary *)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing
{
    GICGradientBackgroundInfo *gradientInfo = parameters[@"gradient"];
    UIColor *bgColor = parameters[@"bgColor"];
    if(![GICUtils isNull:gradientInfo]){
        CGFloat locations[gradientInfo.locations.count];
        for(int i=0;i<gradientInfo.locations.count;i++){
            locations[i] = [gradientInfo.locations[i] floatValue];
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientInfo.colors, locations);
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(bounds.size.width*gradientInfo.start.x, bounds.size.height*gradientInfo.start.y), CGPointMake(bounds.size.width*gradientInfo.end.x, bounds.size.height*gradientInfo.end.y), 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }else if(![GICUtils isNull:bgColor]){
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
        CGContextFillRect(ctx, bounds);
    }
}


+(NSString *)gic_elementName{
    return @"view";
}

-(id)init{
    self =[super init];
    self.automaticallyManagesSubnodes = YES;
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    return [self gic_layoutSpecThatFits:constrainedSize];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:[GICGradientBackgroundInfo gic_elementName]]){
        gradientBackgroundInfo = [GICGradientBackgroundInfo new];
        return gradientBackgroundInfo;
    }
    return [super gic_parseSubElementNotExist:element];
}

- (id<NSObject>)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer{
    return @{
             @"gradient": gradientBackgroundInfo ?: [NSNull null],
             @"bgColor": self.backgroundColor ?: [NSNull null]
             };
}

@end
