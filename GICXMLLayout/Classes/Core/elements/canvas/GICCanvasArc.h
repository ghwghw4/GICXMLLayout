//
//  GICCanvasArc.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasPathPart.h"
@interface GICCanvasArc : GICCanvasPathPart
@property (nonatomic,assign)ASDimensionPoint center;
@property (nonatomic,assign)ASDimension radius;
@property (nonatomic,assign)CGFloat startAngle;
@property (nonatomic,assign)CGFloat endAngle;
@property (nonatomic,assign)BOOL clockwise;
@end
