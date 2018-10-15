//
//  GICJSAPIManager.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/15.
//

#import <Foundation/Foundation.h>
#import "GICJSAPIRegisterProtocl.h"

@interface GICJSAPIManager : NSObject

/**
 添加JSapi的注册器。这个需要在启动APP的时候进行注册添加。以免因为没有及时注册而导致JS执行失败

 @param registerClass <#registerClass description#>
 */
+(void)addJSAPIRegisterClass:(Class<GICJSAPIRegisterProtocl>)registerClass;


/**
 初始化JSContext

 @param jsContext <#jsContext description#>
 */
+(void)initJSContext:(JSContext *)jsContext;


/**
 是否开启当JS执行异常的时候显示提示。(debug的时候使用)
 */
+(void)enableJSExceptionNotify;
@end
