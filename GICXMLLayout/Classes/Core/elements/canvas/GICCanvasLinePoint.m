//
//  GICCanvasLinePoint.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasLinePoint.h"
#import "GICDimensionConverter.h"



@implementation GICCanvasLinePoint
+(NSString *)gic_elementName{
    return @"point";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"x":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasLinePoint *)target setX:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"y":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasLinePoint *)target setY:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              };;
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(CGPoint)convertToPoint:(CGSize)size{
    return CGPointMake(calcuDimensionValue(self.x,size.width), calcuDimensionValue(self.y,size.height));
}

-(void)drawPartPath:(CGContextRef)ctx bounds:(CGRect)bounds{
    CGPoint p = [self convertToPoint:bounds.size];
    CGContextMoveToPoint(ctx, p.x, p.y);
}
@end
