//
//  GICRouterProtocl.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/8.
//

#ifndef GICRouterProtocl_h
#define GICRouterProtocl_h

@protocol GICRouterProtocol <NSObject>
@required
/**
 返回上一页
 */
-(void)goBack;
-(void)goBackWithParams:(id)paramsData;

/**
 根据path导航到下一页。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path <#path description#>
 */
-(void)push:(NSString *)path;

/**
 根据path导航到下一页,并且带有参数。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path <#path description#>
 @param paramsData <#paramsData description#>
 */
-(void)push:(NSString *)path withParamsData:(id)paramsData;


- (void)pushViewController:(UIViewController *)viewController;
@end

#endif /* GICRouterProtocl_h */
