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

@implementation GICCanvasArc
+(NSString *)gic_elementName{
    return @"arc";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"center":[[GICLayoutSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasArc *)target setCenter:[(NSValue *)value ASLayoutSize]];
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

-(void)drawPartPath:(UIBezierPath *)path bounds:(CGRect)bounds{
    [path addArcWithCenter:CGPointMake(calcuDimensionValue(self.center.width,bounds.size.width), calcuDimensionValue(self.center.height,bounds.size.height)) radius:calcuDimensionValue(self.radius,bounds.size.width) startAngle:(self.startAngle / 180) * M_PI endAngle:(self.endAngle / 180) * M_PI clockwise:self.clockwise];
}
@end
