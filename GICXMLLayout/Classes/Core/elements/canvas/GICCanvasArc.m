//
//  GICCanvasArc.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasArc.h"
#import "GICDimensionConverter.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICBoolConverter.h"
#import "GICLayoutSizeConverter.h"
#import "GICDimensionPointConverter.h"

@implementation GICCanvasArc
+(NSString *)gic_elementName{
    return @"arc";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"center":[[GICDimensionPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setCenter:[(NSValue *)value ASDimensionPoint]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"radius":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setRadius:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"start-angle":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setStartAngle:[value floatValue]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"end-angle":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setEndAngle:[value floatValue]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"clockwise":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setClockwise:[value boolValue]];
                  [(id)target gic_setNeedDisplay];
              }],
              };;
}

-(void)drawPartPath:(CGContextRef)ctx bounds:(CGRect)bounds{
    CGContextAddArc(ctx, calcuDimensionValue(self.center.x,bounds.size.width), calcuDimensionValue(self.center.y,bounds.size.height), calcuDimensionValue(self.radius,bounds.size.width), (self.startAngle / 180) * M_PI, (self.endAngle / 180) * M_PI, self.clockwise);
}
@end
