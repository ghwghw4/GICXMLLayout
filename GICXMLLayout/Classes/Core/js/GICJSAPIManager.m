//
//  GICJSAPIManager.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/15.
//

#import "GICJSAPIManager.h"

@implementation GICJSAPIManager
static NSMutableArray<Class<GICJSAPIRegisterProtocl>> *jsAPIRegisterCache;
+(void)initialize{
    jsAPIRegisterCache = [NSMutableArray array];
}

+(void)addJSAPIRegisterClass:(Class<GICJSAPIRegisterProtocl>)registerClass{
    if([registerClass conformsToProtocol:@protocol(GICJSAPIRegisterProtocl)]  && ![jsAPIRegisterCache containsObject:registerClass]){
        [jsAPIRegisterCache addObject:registerClass];
    }
}

+(void)initJSContext:(JSContext *)jsContext{
    [jsAPIRegisterCache enumerateObjectsUsingBlock:^(Class<GICJSAPIRegisterProtocl>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj registeJSAPIToJSContext:jsContext];
    }];
}
@end
