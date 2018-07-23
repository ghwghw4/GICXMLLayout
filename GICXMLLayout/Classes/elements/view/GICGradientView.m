//
//  GICGradientView.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/14.
//

#import "GICGradientView.h"
#import "GICGradientColorsConverter.h"
#import "CGPointConverter.h"
#import "GICNumberConverter.h"

@implementation GICGradientView

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return  @{
              @"colors":[[GICGradientColorsConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  NSArray *a= value;
                  [(GICGradientView *)target setColors:a[0]];
                  [(GICGradientView *)target setLocations:a[1]];
              }],
              @"start":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICGradientView *)target setValue:value forKey:@"start"];
              }],
              @"end":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICGradientView *)target setValue:value forKey:@"end"];
              }],
              @"corner-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASDisplayNode *node = (ASDisplayNode *)target;
                  node.cornerRadius = [value floatValue];
              }],
              };;
}

+(NSString *)gic_elementName{
    return @"gradient-view";
}

-(id)init{
    self = [super init];
    _end = CGPointMake(1, 1);
    return self;
}

-(void)gic_parseElementCompelete{
    [super gic_parseElementCompelete];
}

- (void)generateIamge
{
    CGSize size = self.frame.size;
    UIGraphicsBeginImageContext(size);
    CGFloat locations[self.locations.count];
    for(int i=0;i<self.locations.count;i++){
        locations[i] = [self.locations[i] floatValue];
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)self.colors, locations);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(size.width*_start.x, size.height*_start.y), CGPointMake(size.width*_end.x, size.height*_end.y), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)layout{
    [super layout];
    [self generateIamge];
}

//- (id<NSObject>)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer{
//    return @{
//             @"colors": self.colors ?: [NSNull null],
//             @"locations": self.locations ?: [NSNull null],
//             @"start": NSStringFromCGPoint(self.start) ?: [NSNull null],
//             @"end": NSStringFromCGPoint(self.end) ?: [NSNull null],
//             };
//}
@end
