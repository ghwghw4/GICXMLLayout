//
//  GICCanvasPathPart.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/8.
//

#import "GICCanvasPathPart.h"

@implementation GICCanvasPathPart
-(void)drawPartPath:(CGContextRef)ctx bounds:(CGRect)bounds{
    
}

#pragma mark GICDisplayProtocol
-(void)gic_setNeedDisplay{
    [self.gic_getSuperElement gic_setNeedDisplay];
}
@end
