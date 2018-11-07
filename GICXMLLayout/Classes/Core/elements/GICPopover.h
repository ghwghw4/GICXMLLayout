//
//  GICPopover.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import <Foundation/Foundation.h>
#import "GICPanel.h"
// 弹出框
@interface GICPopover : UIViewController
/**
 显示弹框

 @param animation 是否有动画
 */
-(void)present:(BOOL)animation;

// 隐藏弹框
-(void)dismiss:(BOOL)animation;

/**
 加载Popover内容，内容必须是模板

 @param templateName 模板名称
 @param element 能够找到该模板的元素。(逐级往上找寻模板)
 @return <#return value description#>
 */
//+(GICPopover *)loadPopoverContent:(NSString *)templateName fromElement:(id)element;

+(GICPopover *)loadPopoverPage:(NSString *)pagePath fromElement:(id)element;
@end
