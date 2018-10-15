//
//  GICJSAPIManager.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/15.
//

#import "GICJSAPIManager.h"

@implementation GICJSAPIManager
static NSMutableArray<Class<GICJSAPIRegisterProtocl>> *jsAPIRegisterCache;
static bool jsExceptionNotify = false;
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
    //
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        if(jsExceptionNotify){
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            ASTextNode *lbl = [[ASTextNode alloc] init];
            lbl.backgroundColor  = [UIColor whiteColor];
            lbl.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"JSException: %@",exception] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
            lbl.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
            CGSize size = [lbl calculateSizeThatFits:CGSizeMake(window.bounds.size.width, MAXFLOAT)];
            lbl.frame = CGRectMake(0, 20, window.bounds.size.width, size.height + 10);
            [window addSubview:lbl.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [lbl.view removeFromSuperview];
            });
        }
        NSLog(@"JSException: %@",exception);
    };
}

+(void)enableJSExceptionNotify{
    jsExceptionNotify = true;
}
@end
