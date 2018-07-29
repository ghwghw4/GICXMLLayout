//
//  ASDisplayNode+GICExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASDisplayNode (GICExtension)

/**
 线程安全获取view

 @param cb <#cb description#>
 */
-(void)gic_safeView:(void (^)(UIView *view))cb;

-(void)layoutAttributeChanged;

-(NSArray<ASDisplayNode*> *)gic_displayNodes;
@end
