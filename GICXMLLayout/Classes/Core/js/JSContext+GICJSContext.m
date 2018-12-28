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
#import "GICRegeneratorRuntime.h"

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
            if(![function[@"isCancelled"] toBool]){
                [function callWithArguments:@[]];
            }
        });
        function[@"isCancelled"] = @(NO);
        return function;
    };
    
    self[@"clearTimeout"] = ^(JSValue *t){
        t[@"isCancelled"] = @(YES);
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
    self[@"console"] = [[GICJSConsole alloc] init];
#if DEBUG
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
    
    // 增加Promise API
    NSString *promiseString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle GICXMLLayoutBundle] pathForResource:@"Promise" ofType:@"js"]] encoding:4];
    [self evaluateScript:promiseString];
    
    
    // 添加require 方法. 以便动态加载JS
    self[@"require"] = ^id(NSString *path,JSValue *isModule){
        // 先从缓存中获取
        JSValue *module = [[JSContext currentContext].globalObject[@"Module"] invokeMethod:@"_fromCache" withArguments:@[path]];
        if([module isNull] || [module isUndefined]){
            NSData *jsData = [GICXMLLayout loadDataFromPath:path];
            NSString *js = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
            NSString *pathExtension =[path pathExtension];
            
            if([pathExtension isEqualToString:@"js"]){
                module = [[JSContext currentContext].globalObject[@"Module"] invokeMethod:@"requireJS" withArguments:@[path,js,isModule]];
            }else if ([pathExtension isEqualToString:@"json"]){
                module = [[JSContext currentContext].globalObject[@"Module"] invokeMethod:@"requireJson" withArguments:@[path,js]];
            }
            
            if(!([isModule isNull] || [isModule isUndefined] || [isModule toBool])){
                [[JSContext currentContext] evaluateScript:js];
            }
        }
        return module[@"exports"];
    };
    
    self[@"regeneratorRuntime"] = [GICRegeneratorRuntime class];
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

