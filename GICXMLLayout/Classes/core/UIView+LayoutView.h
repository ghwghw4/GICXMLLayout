//
//  UIView+LayoutView.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>
#import "NSObject+LayoutElement.h"

@class GDataXMLElement;

@interface UIView (LayoutView)<LayoutElementProtocol>

/**
 通用的子元素布局

 @param subView <#subView description#>
 */
-(void)gic_LayoutSubView:(UIView *)subView;
@end
