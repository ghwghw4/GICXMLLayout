//
//  GICJSCore.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import "GICJSCore.h"
#import "GICJSConsole.h"
#import "GICXMLHttpRequest.h"
#import "NSBundle+GICXMLLayout.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JSBase.h>
#import "GICGCDTimer.h"
#import "GICJSAPIManager.h"
#import "GICJSDocument.h"

// 立即同步执行JS的垃圾回收机制(既然苹果没有将整个API开放出来，我个人觉得还是慎用为上，因为js本身有独立的垃圾回收机制，我们不应该强制的去干预)
void JSSynchronousGarbageCollectForDebugging(JSContextRef ctx);

@implementation NSObject (GICScript)
-(JSContext *)gic_JSContext{
    return objc_getAssociatedObject(self, "gic_JSContext");
}

-(void)setGic_JSContext:(JSContext *)jsContext{
    objc_setAssociatedObject(self, "gic_JSContext", jsContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface GICJSCore()<GICJSAPIRegisterProtocl>
@end

@implementation GICJSCore
+(void)initialize{
    // 添加API注册器
    [GICJSAPIManager addJSAPIRegisterClass:[self class]];
}
+(JSContext *)findJSContextFromElement:(NSObject *)element{
    JSContext *context = [element gic_JSContext];
    if(context){
        return context;
    }
    NSObject *superEl = [element gic_getSuperElement];
    if(superEl == nil){
        context = [[JSContext alloc] init];
        // 注入GICJSCore
        context[@"document"] = [[GICJSDocument alloc] initRootElement:element];
        [self extend:context];
        [element setGic_JSContext:context];
        return context;
    }
    return [self findJSContextFromElement:superEl];
}

+(void)extend:(JSContext *)context { return [self extend:context logHandler:nil]; }
+(void)extend:(JSContext*)context logHandler:(void (^)(NSString*,NSArray*,NSString*))logHandler;
{
    context[@"console"] = [[GICJSConsole alloc] initWithLogHandler:logHandler];
    [GICJSAPIManager initJSContext:context];
//    context[@"createElement"] = ^{
//        NSArray<JSValue *> *args = [JSContext currentArguments];
//        NSString *elementName = [[args firstObject] toString];
//        Class c = [GICElementsCache classForElementName:elementName];
//        return [c new];
//    };
}


+(void)registeJSAPIToJSContext:(JSContext*)context{
    // 添加setTimeout方法
    context[@"setTimeout"] = ^(JSValue* function, JSValue* timeout) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([timeout toInt32] * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [function callWithArguments:@[]];
        });
    };
    
    context[@"setInterval"] =^(JSValue* function, JSValue* timeout) {
        GICGCDTimer *timer = [GICGCDTimer scheduledTimerWithTimeInterval:(uint64_t)([timeout toInt32] *NSEC_PER_MSEC) block:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [function callWithArguments:@[]];
            });
        } queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        return timer;
    };
    
    context[@"clearInterval"] = ^(JSValue *jsTimer){
        GICGCDTimer *timer = [jsTimer toObject];
        [timer invalidate];
    };
    
    // 添加alert 方法
    context[@"alert"] = ^(JSValue* message){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[message toString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    };
    
    context[@"XMLHttpRequest"] = [GICXMLHttpRequest class];
    
    // 垃圾回收。为了能够及时回收内存，GC的调用很有必要。
    context[@"gc"] = @{};
    context[@"gc"][@"collect"] = ^(JSValue *sync){
        if([sync toBool]){
            // 强制同步调用
            JSSynchronousGarbageCollectForDebugging([JSContext currentContext].JSGlobalContextRef);
        }else{
            // 这种方式并不会立即执行垃圾回收，而是会在下一次的"时机"到了就会去执行，相对于完全不调用来说，这种方式垃圾收集的时机会更加的靠前
            JSGarbageCollect([JSContext currentContext].JSGlobalContextRef);
        }
    };
    NSString *jsCoreString = [NSBundle gic_jsCoreString];
    [context evaluateScript:jsCoreString];
}
@end
