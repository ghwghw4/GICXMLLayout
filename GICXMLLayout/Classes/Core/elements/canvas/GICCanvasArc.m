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

@implementation GICCanvasArc
+(NSString *)gic_elementName{
    return @"arc";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"center":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASLayoutSize size = ASLayoutSizeMakeFromString(value);
                  [(GICCanvasArc *)target setCenter:size];
              }],
              @"radius":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setRadius:ASDimensionMake((NSString *)value)];
              }],
              @"start-angle":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setStartAngle:[value floatValue]];
              }],
              @"end-angle":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setEndAngle:[value floatValue]];
              }],
              @"clockwise":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setClockwise:[value boolValue]];
              }],
              };;
}


-(UIBezierPath *)createBezierPath:(CGRect)bounds{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(calcuDimensionValue(self.center.width,bounds.size.width), calcuDimensionValue(self.center.height,bounds.size.height)) radius:calcuDimensionValue(self.radius,bounds.size.width) startAngle:(self.startAngle / 180) * M_PI endAngle:(self.endAngle / 180) * M_PI clockwise:self.clockwise];
    return path;
}

@end
