//
//  GICPanel.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>
#import "UIView+GICExtension.h"
#import <Masonry/Masonry.h>

@interface GICPanel : UIView<LayoutElementProtocol>
-(void)setTopConstrant:(MASConstraintMaker *)make marginTop:(CGFloat)top;
-(void)setHeightBottomConstrant:(MASConstraintMaker *)make view:(UIView *)view margin:(UIEdgeInsets)margin;

/**
 计算实际的高度

 @return 高度
 */
-(CGFloat)calcuActualHeight;
@end
