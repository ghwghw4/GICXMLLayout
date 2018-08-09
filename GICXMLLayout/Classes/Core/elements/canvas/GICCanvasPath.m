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
#import "GICCanvasLine.h"
#import "GICCanvasRectangle.h"
#import "GICCanvasArc.h"
#import "GICCanvasLinePoint.h"

@interface GICCanvasPath(){
    NSMutableArray<GICCanvasPathPart *> *parts;
}
@end

@implementation GICCanvasPath
+(NSString *)gic_elementName{
    return @"path";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"line-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setLineColor:value];
                  [(id)target gic_setNeedDisplay];
              }],
              @"close-lines":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setIsCloseLines:[value boolValue]];
                  [(id)target gic_setNeedDisplay];
              }],
              @"line-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setLineWidth:[value floatValue]];
                  [(id)target gic_setNeedDisplay];
              }],
              
              @"fill-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasPath *)target setFillColor:value];
                  [(id)target gic_setNeedDisplay];
              }],
              };;
}

-(id)init{
    self = [super init];
    _lineWidth = 0.5;
    parts = [NSMutableArray array];
    return self;
}

-(void)draw:(CGContextRef)ctx withBounds:(CGRect)bounds{
    [parts enumerateObjectsUsingBlock:^(GICCanvasPathPart * _Nonnull part, NSUInteger idx, BOOL * _Nonnull stop) {
        [part drawPartPath:ctx bounds:bounds];
    }];
  
    if(self.isCloseLines){
        CGContextClosePath(ctx);
    }
    
    CGContextSetLineWidth(ctx, self.lineWidth);
    if(self.fillColor && self.lineWidth>0){
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        return;
    }
   
    if(self.fillColor){
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextFillPath(ctx);
    }
    
    if(self.lineWidth>0){
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        CGContextStrokePath(ctx);
    }
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICCanvasPathPart class]]){
        [parts addObject:subElement];
        return subElement;
    }
    return [super gic_addSubElement:subElement];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:[GICCanvasLinePoint gic_elementName]]){
        return [GICCanvasLinePoint new];
    }else if([element.name isEqualToString:[GICCanvasRectangle gic_elementName]]){
        return [GICCanvasRectangle new];
    }else if([element.name isEqualToString:[GICCanvasArc gic_elementName]]){
        return [GICCanvasArc new];
    }else if([element.name isEqualToString:[GICCanvasLine gic_elementName]]){
        return [GICCanvasLine new];
    }
    return [super gic_parseSubElementNotExist:element];
}

#pragma mark GICDisplayProtocol
-(void)gic_setNeedDisplay{
    [self.gic_getSuperElement gic_setNeedDisplay];
}
@end
