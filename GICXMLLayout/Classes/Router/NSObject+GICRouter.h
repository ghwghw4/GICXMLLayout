//
//  NSObject+GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/6.
//

#import <Foundation/Foundation.h>
#import "GICPage.h"

@interface NSObject (GICRouter)
//-(UINavigationController *)gic_Router;

/**
 获取当前页面。
 tips:这里面之所以没有使用UINavigationController来作为router，是因为对于在实际的开发中，开发者不要太过于关注NavigationController，应该尽可能的将注意力放在page上面。一切跟导航相关的都交给GIC来处理就行了。因此这里在最终设计的时候直接废弃了gic_Router这个方法。
 @return <#return value description#>
 */
-(GICPage *)gic_CurrentPage;
@end
