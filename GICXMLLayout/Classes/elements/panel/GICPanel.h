//
//  GICPanel.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>
#import "UIView+GICExtension.h"

/**
 Panle的作用其实就是类似于UIView，也类似于Hmtl中的canvas布局。
 所有的元素都是绝对布局。
 */
@interface GICPanel : ASDisplayNode<LayoutElementProtocol>
@property (nonatomic,strong,readonly)ASLayoutSpec *layoutSpec;
//-(void)layoutView:(UIView *)view;
-(id)initWithLayoutSpec:(ASLayoutSpec *)layoutSpec;
@end
