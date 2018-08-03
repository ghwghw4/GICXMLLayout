//
//  GICCanvasRectangle.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvasPath.h"

@interface GICCanvasRectangle : GICCanvasPath
@property (nonatomic,assign)ASDimension x;
@property (nonatomic,assign)ASDimension y;

@property (nonatomic,assign)ASDimension width;
@property (nonatomic,assign)ASDimension height;

@property (nonatomic,assign)UIRectCorner cornerTypes;
@property (nonatomic,assign)ASLayoutSize cornerRadiusSize;
@end
