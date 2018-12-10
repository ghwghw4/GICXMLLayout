//
//  GICRouterJSAPIExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/17.
//

#import <Foundation/Foundation.h>
#import "GICJSAPIRegisterProtocl.h"
#import "GICPage.h"
#import "GICXMLParserContext.h"

@interface GICRouterJSAPIExtension : NSObject<GICJSAPIRegisterProtocl>
//+(void)setJSParamsData:(id)paramsData withPage:(GICPage *)page;
//+(void)goBackWithParmas:(id)paramsData fromPage:(GICPage *)page;
+(void)goBackFromPage:(GICPage *)page;
@end
