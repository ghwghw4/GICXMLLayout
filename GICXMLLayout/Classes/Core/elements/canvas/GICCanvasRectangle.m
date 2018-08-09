//
//  GICCanvasRectangle.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasRectangle.h"
#import "GICDimensionConverter.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICLayoutSizeConverter.h"

@implementation GICCanvasRectangle

+(NSString *)gic_elementName{
    return @"rectangle";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"x":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasRectangle *)target setX:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"y":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasRectangle *)target setY:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"width":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasRectangle *)target setWidth:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"height":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasRectangle *)target setHeight:[(NSValue *)value ASDimension]];
                  [(id)target gic_setNeedDisplay];
              }],
              // 支持绑定，但不支持动画
              @"corner-types":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  NSArray *strs =[value componentsSeparatedByString:@" "];
                  UIRectCorner t = 0;
                  for(NSString *str in strs){
                      switch ([str integerValue]) {
                          case 0:
                              {
                                  t = t | UIRectCornerTopLeft;
                              }
                              break;
                          case 1:
                          {
                              t = t | UIRectCornerTopRight;
                          }
                              break;
                          case 2:
                          {
                              t = t | UIRectCornerBottomLeft;
                          }
                              break;
                          case 3:
                          {
                              t = t | UIRectCornerBottomRight;
                          }
                              break;
                              
                          default:
                              break;
                      }
                  }
                  [(GICCanvasRectangle *)target setCornerTypes:t];
              }],
              @"corner-radius":[[GICLayoutSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasRectangle *)target setCornerRadiusSize:[(NSValue *)value ASLayoutSize]];
                  [(id)target gic_setNeedDisplay];
              }],
              };;
}

-(id)init{
    self = [super init];
    _cornerTypes = UIRectCornerAllCorners;
    return self;
}

-(UIBezierPath *)createBezierPath:(CGRect)bounds{
    UIBezierPath *path = nil;
    CGRect rect= CGRectMake(bounds.origin.x +calcuDimensionValue(self.x,bounds.size.width), bounds.origin.y+calcuDimensionValue(self.y,bounds.size.height), calcuDimensionValue(self.width,bounds.size.width), calcuDimensionValue(self.height,bounds.size.height));
    
    CGSize raidoSize = CGSizeMake(calcuDimensionValue(self.cornerRadiusSize.width,rect.size.width), calcuDimensionValue(self.cornerRadiusSize.height,rect.size.height));
    
    if(CGSizeEqualToSize(raidoSize, CGSizeZero)){
        path = [UIBezierPath bezierPathWithRect:rect];
    }else{
        path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.cornerTypes cornerRadii:raidoSize];
    }
    return path;
}

-(void)drawPartPath:(CGContextRef)ctx bounds:(CGRect)bounds{
    UIBezierPath *path = [self createBezierPath:bounds];
    CGContextAddPath(ctx, path.CGPath);
}
@end
