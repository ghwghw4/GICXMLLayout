//
//  GICPageRouterProtocol.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/8.
//

#ifndef GICPageRouterProtocol_h
#define GICPageRouterProtocol_h
#import "GICRouterParams.h"

@protocol GICPageRouterProtocol <NSObject>

/**
 导航到当前页面的回调

 @param params 导航带过来的参数
 */
-(void)navigationWithParams:(GICRouterParams *)params;
@optional

/**
 从前一页返回到当前页面的回调

 @param params 返回参数
 */
-(void)navigationBackWithParams:(GICRouterParams *)params;
@end


#endif /* GICPageRouterProtocol_h */
