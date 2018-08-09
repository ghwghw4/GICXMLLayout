//
//  GICCanvasPath.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import <UIKit/UIKit.h>

@interface GICCanvasPath : NSObject<GICDisplayProtocol>
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)BOOL isCloseLines;
@property (nonatomic,assign)CGFloat lineWidth;


@property (nonatomic,strong)UIColor *fillColor;
-(void)draw:(CGContextRef)ctx withBounds:(CGRect)bounds;

//-(UIBezierPath *)createBezierPath:(CGRect)bounds;
@end
