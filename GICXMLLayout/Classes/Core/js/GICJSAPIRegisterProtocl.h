//
//  GICJSRegisterProtocl.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/12.
//

#ifndef GICJSAPIRegisterProtocl_h
#define GICJSAPIRegisterProtocl_h
#import <JavaScriptCore/JavaScriptCore.h>

/**
 JSAPI注册器
 */
@protocol GICJSAPIRegisterProtocl <NSObject>
// 将JSAPI 注入JSContext中
+(void)registeJSAPIToJSContext:(JSContext*)context;
@end
#endif /* GICJSAPIRegisterProtocl_h */
