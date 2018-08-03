//
//  GICCanvasLine.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import <UIKit/UIKit.h>
#import "GICCanvasPath.h"

@interface GICCanvasLine : GICCanvasPath
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)BOOL isCloseLines;
@end
