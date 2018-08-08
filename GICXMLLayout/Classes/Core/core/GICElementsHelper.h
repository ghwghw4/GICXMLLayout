//
//  GICElementsHelper.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/7.
//

#import <Foundation/Foundation.h>

/**
 专门用来查询元素的辅助类
 */
@interface GICElementsHelper : NSObject
/**
 根据name，从父元素上查找name为给定字符串的第一个子元素

 @param name <#name description#>
 @return <#return value description#>
 */
+(id)findSubElementFromSuperElement:(id)superElment withName:(NSString *)name;


/**
 根据name 和 viewModel，查找元素名为name的第一个元素

 @param viewModel <#viewModel description#>
 @param name <#name description#>
 @return <#return value description#>
 */
+(id)findElementFromViewModel:(id)viewModel withName:(NSString *)name;
@end
