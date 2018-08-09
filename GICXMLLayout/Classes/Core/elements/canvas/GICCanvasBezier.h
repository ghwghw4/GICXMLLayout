//
//  GICCanvasBezier.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import <Foundation/Foundation.h>
#import "GICCanvasPathPart.h"
@interface GICCanvasBezier : GICCanvasPathPart{
    BOOL hasSetControlPoint22;
}
@property (nonatomic,assign)ASDimensionPoint controlPoint;
@property (nonatomic,assign)ASDimensionPoint controlPoint2;
@property (nonatomic,assign)ASDimensionPoint point;
@end
