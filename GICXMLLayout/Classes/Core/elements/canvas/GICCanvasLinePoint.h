//
//  GICCanvasLinePoint.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import <Foundation/Foundation.h>
#import "GICCanvasPathPart.h"

@interface GICCanvasLinePoint : GICCanvasPathPart
@property (nonatomic,assign)ASDimension x;
@property (nonatomic,assign)ASDimension y;

-(CGPoint)convertToPoint:(CGSize)size;
@end
