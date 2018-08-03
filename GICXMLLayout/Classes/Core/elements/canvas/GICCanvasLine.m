//
//  GICCanvasLine.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasLine.h"
#import "GICCanvasLinePoint.h"
#import "GICColorConverter.h"
#import "GICBoolConverter.h"
#import "GICNumberConverter.h"

@interface GICCanvasLine (){
    NSMutableArray<GICCanvasLinePoint *> *points;
}

@end

@implementation GICCanvasLine
+(NSString *)gic_elementName{
    return @"line";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasLine *)target setLineColor:value];
              }],
              @"close":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasLine *)target setIsCloseLines:[value boolValue]];
              }],
              @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICCanvasLine *)target setLineWidth:[value floatValue]];
              }],
              };;
}

-(id)init{
    self = [super init];
    points = [NSMutableArray array];
    return self;
}


-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICCanvasLinePoint class]]){
        [points addObject:subElement];
        return subElement;
    }
    return [super gic_addSubElement:subElement];
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:@"point"]){
        return [GICCanvasLinePoint new];
    }
    return [super gic_parseSubElementNotExist:element];
}

-(void)draw:(CGRect)bounds{
    [self removeAllPoints];
    [self.lineColor set];
    [points enumerateObjectsUsingBlock:^(GICCanvasLinePoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = [obj convertToPoint:bounds.size];
        if(idx==0){
            [self moveToPoint:p];
        }else{
            [self addLineToPoint:p];
        }
    }];
    if(self.isCloseLines){
        [self closePath];
    }
    [self stroke];
}
@end
