//
//  GICPanel.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>

/**
 Panle的作用其实就是类似于UIView，也类似于Hmtl中的canvas布局。
 所有的元素都是绝对布局。
 */
@interface GICPanel : NSObject<LayoutElementProtocol>
@property (nonatomic,strong,readonly)NSMutableArray *childNodes;
//@property (nonatomic,weak)ASDisplayNode *superDisplayNode;

@property (nonatomic, readonly) ASLayoutElementStyle *style;


-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize;

/**
 由子类实现

 @param constrainedSize <#constrainedSize description#>
 @param children <#children description#>
 @return <#return value description#>
 */
-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize withChildren:(NSArray *)children;

-(NSArray<ASDisplayNode *> *)getAllDisplayNodes;

-(void)mergeStyle:(ASLayoutSpec *)spec;
@end
