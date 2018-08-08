//
//  GICPage.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <UIKit/UIKit.h>
#import "GICRouterParams.h"

@interface GICPage : ASViewController{
//    id _viewModel;
}
#pragma mark router

/**
 导航参数。这个参数只有在push、并且带有参数的情况下才会设置
 */
@property (nonatomic,strong)GICRouterParams *navParams;

/**
 返回上一页
 */
-(void)goBack;

/**
 根据path导航到下一页。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path <#path description#>
 */
-(void)go:(NSString *)path;

/**
 根据path导航到下一页,并且带有参数。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path <#path description#>
 @param paramsData <#paramsData description#>
 */
-(void)go:(NSString *)path withParamsData:(id)paramsData;
@end
