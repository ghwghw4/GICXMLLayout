//
//  GICCanvasPath.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasPath.h"
#import "GICColorConverter.h"
#import "GICBoolConverter.h"
#import "GICNumberConverter.h"

@implementation GICCanvasPath
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"line-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setLineColor:value];
              }],
              @"close-lines":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setIsCloseLines:[value boolValue]];
              }],
              @"line-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setLineWidth:[value floatValue]];
              }],
              
              @"fill-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setFillColor:value];
              }],
              };;
}

-(id)init{
    self = [super init];
    _lineWidth = 0.5;
    return self;
}

-(void)draw:(CGRect)bounds{
    UIBezierPath *path = [self createBezierPath:bounds];
  
    if(self.isCloseLines){
        [path closePath];
    }
    if(self.lineWidth>0){
        [self.lineColor setStroke];
        path.lineWidth = self.lineWidth;
        [path stroke];
    }
    if(self.fillColor){
        [self.fillColor setFill];
        [path fill];
    }
}

-(UIBezierPath *)createBezierPath:(CGRect)bounds{
    return nil;
}
@end
