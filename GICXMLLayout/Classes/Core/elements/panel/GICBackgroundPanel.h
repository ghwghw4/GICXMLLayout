//
//  GICBackgroundPanel.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICPanel.h"

/**
 背景布局
 */
@interface GICBackgroundPanel : GICPanel
@property (nonatomic,weak,readonly)ASDisplayNode *backgroundNode;
@property (nonatomic,weak,readonly)ASDisplayNode *childNode;
@end
