//
//  GICCanvasArc.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasPath.h"
@interface GICCanvasArc : GICCanvasPath
@property (nonatomic,assign)ASLayoutSize center;
@property (nonatomic,assign)ASDimension radius;
@property (nonatomic,assign)CGFloat startAngle;
@property (nonatomic,assign)CGFloat endAngle;
@property (nonatomic,assign)BOOL clockwise;
@end
