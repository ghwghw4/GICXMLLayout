//
//  GICListView.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <UIKit/UIKit.h>

@interface GICListView : ASTableNode<LayoutElementProtocol>

/**
 默认item的高度。当item首次初始化的时候以默认高度为初始高度。这样主要是为了充分利用taleview的可重用特性来提高首次显示速度。如果设为0，那么久意味着第一次加载的时候无法利用可重用的特性，会一下子加载全部的tableview，这样一来会出现卡顿的现象。
 另外为了提高性能，分页item尽可能的减少数量。最好控制在10条左右
 */
@property (nonatomic,assign)CGFloat defualtItemHeight;

//@property (no)
@end
