//
//  GICCanvasBezier.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import "GICCanvasBezier.h"
//#import "GICLayoutSizeConverter.h"
#import "GICDimensionPointConverter.h"

@implementation GICCanvasBezier
+(NSString *)gic_elementName{
    return @"bezier";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"control-point":[[GICDimensionPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasBezier *)target setControlPoint:[(NSValue *)value ASDimensionPoint]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"control-point2":[[GICDimensionPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasBezier *)target setControlPoint2:[(NSValue *)value ASDimensionPoint]];
                  [(id)target gic_setNeedDisplay];
              }],
              
              @"point":[[GICDimensionPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasBezier *)target setPoint:[(NSValue *)value ASDimensionPoint]];
                  [(id)target gic_setNeedDisplay];
              }],
              
             
              };;
}

-(void)setControlPoint2:(ASDimensionPoint)controlPoint2{
    _controlPoint2 = controlPoint2;
    hasSetControlPoint22 = YES;
}

-(CGPoint)convertASDimensionPointToPoint:(ASDimensionPoint)point withSize:(CGSize)size{
    return CGPointMake(calcuDimensionValue(point.x,size.width), calcuDimensionValue(point.y,size.height));
}

-(void)drawPartPath:(CGContextRef)ctx bounds:(CGRect)bounds{
    CGPoint controlPoint = [self convertASDimensionPointToPoint:self.controlPoint withSize:bounds.size];
    CGPoint point = [self convertASDimensionPointToPoint:self.point withSize:bounds.size];
    if(hasSetControlPoint22){
        CGPoint controlPoint2 = [self convertASDimensionPointToPoint:self.controlPoint2 withSize:bounds.size];
        CGContextAddCurveToPoint(ctx, controlPoint.x, controlPoint.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
    }else{
        CGContextAddQuadCurveToPoint(ctx, controlPoint.x, controlPoint.y, point.x, point.y);
    }
}

@end
