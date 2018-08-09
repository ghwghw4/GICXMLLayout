//
//  GICCanvasLine.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasLine.h"
#import "GICCanvasLinePoint.h"


@interface GICCanvasLine (){
    NSMutableArray<GICCanvasLinePoint *> *points;
}

@end

@implementation GICCanvasLine
+(NSString *)gic_elementName{
    return @"line";
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

-(void)drawPartPath:(UIBezierPath *)path bounds:(CGRect)bounds{
    [points enumerateObjectsUsingBlock:^(GICCanvasLinePoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = [obj convertToPoint:bounds.size];
        if(idx==0){
            [path moveToPoint:p];
        }else{
            [path addLineToPoint:p];
        }
    }];
}
@end
