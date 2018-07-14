//
//  GICGradientView.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/14.
//

#import "GICGradientView.h"
#import "GICGradientColorsConverter.h"
#import "CGPointConverter.h"

@implementation GICGradientView
+ (void)drawRect:(CGRect)bounds withParameters:(NSDictionary *)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing
{
    
    NSArray *colors = parameters[@"colors"];
    NSArray *locationsArray = parameters[@"locations"];
    CGPoint start = CGPointFromString(parameters[@"start"]);
    CGPoint end = CGPointFromString(parameters[@"end"]);
    
    CGFloat locations[locationsArray.count];
    for(int i=0;i<locationsArray.count;i++){
        locations[i] = [locationsArray[i] floatValue];
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(bounds.size.width*start.x, bounds.size.height*start.y), CGPointMake(bounds.size.width*end.x, bounds.size.height*end.y), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

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

- (id<NSObject>)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer{
    return @{
             @"colors": self.colors ?: [NSNull null],
             @"locations": self.locations ?: [NSNull null],
             @"start": NSStringFromCGPoint(self.start) ?: [NSNull null],
             @"end": NSStringFromCGPoint(self.end) ?: [NSNull null],
             };
}
@end
