//
//  ASDisplayNode+GICExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GICPanel.h"

@interface ASDisplayNode (GICExtension)

@property (nonatomic,strong)GICPanel *gic_panel;

/**
 线程安全获取view

 @param cb <#cb description#>
 */
-(void)gic_safeView:(void (^)(UIView *view))cb;


- (ASLayoutSpec *)gic_layoutSpecThatFits:(ASSizeRange)constrainedSize;
@end
