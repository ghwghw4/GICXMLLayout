//
//  JSContext+GICJSContext.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/12.
//

#import "JSContext+GICJSContext.h"
#import "GICJSDocument.h"
#import "NSBundle+GICXMLLayout.h"
#import "GICGCDTimer.h"
#import "GICXMLHttpRequest.h"
#import "GICJSConsole.h"
#import "JSValue+GICJSExtension.h"

#if DEBUG
// 立即同步执行JS的垃圾回收机制(既然苹果没有将整个API开放出来，我个人觉得还是慎用为上，因为js本身有独立的垃圾回收机制，我们不应该强制的去干预)
void JSSynchronousGarbageCollectForDebugging(JSContextRef ctx);
#endif


@implementation JSContext (GICJSContext)
-(void)setRootDataContext:(JSValue *)dataContext{
    self[@"__rootDataContext__"] = dataContext;
}

-(JSValue *)rootDataContext{
    return self[@"__rootDataContext__"];
}

-(BOOL)isSetRootDataContext{
    return ![[self rootDataContext] isUndefined];
}

-(void)registCoreAPI{
    self[@"__rootDataContext__"] = nil;
    
    // 添加setTimeout方法
    self[@"setTimeout"] = ^(JSValue* function, JSValue* timeout) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([timeout toInt32] * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [function callWithArguments:@[]];
        });
    };
    
    self[@"document"] = [[GICJSDocument alloc] init];
    
    self[@"setInterval"] =^(JSValue* function, JSValue* timeout) {
        GICGCDTimer *timer = [GICGCDTimer scheduledTimerWithTimeInterval:(uint64_t)([timeout toInt32] *NSEC_PER_MSEC) block:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [function callWithArguments:@[]];
            });
        } queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        return timer;
    };
    
    self[@"clearInterval"] = ^(JSValue *jsTimer){
        GICGCDTimer *timer = [jsTimer toObject];
        [timer invalidate];
    };
    
    // 添加alert 方法
    self[@"alert"] = ^(JSValue* message){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[message toString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    };
    
    self[@"XMLHttpRequest"] = [GICXMLHttpRequest class];
#if DEBUG
    self[@"console"] = [[GICJSConsole alloc] initWithLogHandler:nil];
    
    // 垃圾回收。为了能够及时回收内存，GC的调用很有必要。
    self[@"gc"] = @{};
    self[@"gc"][@"collect"] = ^(JSValue *sync){
        if([sync toBool]){
            // 强制同步调用
            JSSynchronousGarbageCollectForDebugging([JSContext currentContext].JSGlobalContextRef);
        }else{
            // 这种方式并不会立即执行垃圾回收，而是会在下一次的"时机"到了就会去执行，相对于完全不调用来说，这种方式垃圾收集的时机会更加的靠前
            JSGarbageCollect([JSContext currentContext].JSGlobalContextRef);
        }
    };
#endif
    
    
    NSString *jsCoreString = [NSBundle gic_jsCoreString];
    [self evaluateScript:jsCoreString];
//    // 注册nativeAPI
//    [self evaluateScript:[NSBundle gic_jsNativeAPIString]];
//    self[@"_native_"] = [[GICJSNativeAPI alloc] init];
    
    // 添加require 方法. 以便动态加载JS
    self[@"require"] = ^(NSString *jsPath){
        NSData *jsData = [GICXMLLayout loadDataFromPath:jsPath];
        NSString *js = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
        [[JSContext currentContext] evaluateScript:js];
    };
}

-(void)setRootElement:(GICJSElementDelegate *)rootElement{
    self[@"__rootElement__"] = rootElement;
}

-(GICJSElementDelegate *)rootElement{
    return [self[@"__rootElement__"] toObject];
}

-(JSValue *)excuteJSString:(NSString *)jsString withArguments:(NSArray *)arguments{
    return [self.globalObject excuteJSString:jsString withArguments:arguments];
}
@end