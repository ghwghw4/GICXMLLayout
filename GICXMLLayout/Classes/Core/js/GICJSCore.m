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

@implementation NSObject (GICScript)
-(JSContext *)gic_JSContext{
    return objc_getAssociatedObject(self, "gic_JSContext");
}

-(void)setGic_JSContext:(JSContext *)jsContext{
    objc_setAssociatedObject(self, "gic_JSContext", jsContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation GICJSCore
+(JSContext *)findJSContextFromElement:(NSObject *)element{
    JSContext *context = [element gic_JSContext];
    if(context){
        return context;
    }
    NSObject *superEl = [element gic_getSuperElement];
    if(superEl == nil){
        context = [[JSContext alloc] init];
        context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"JSException: %@",exception);
        };
        // 注入GICJSCore
        [self extend:context];
        
        [element setGic_JSContext:context];
        return context;
    }
    return [self findJSContextFromElement:superEl];
}

+(void)extend:(JSContext *)context { return [self extend:context logHandler:nil]; }
+(void)extend:(JSContext*)context logHandler:(void (^)(NSString*,NSArray*,NSString*))logHandler;
{
 
    context[@"window"] = @{};
    // 添加setTimeout方法
    context[@"setTimeout"] = ^(JSValue* function, JSValue* timeout) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([timeout toInt32] * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [function callWithArguments:@[]];
        });
    };
    // 添加alert 方法
    context[@"alert"] = ^(JSValue* message){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[message toString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    };
    
    context[@"XMLHttpRequest"] = [GICXMLHttpRequest class];
    context[@"console"] = [[GICJSConsole alloc] initWithLogHandler:logHandler];
    
    NSString *jsCoreString = [NSBundle gic_jsCoreString];
    [context evaluateScript:jsCoreString];
//    [context evaluateScript:@"var GIC = window.GIC;"];
    
//    context[@"createElement"] = ^{
//        NSArray<JSValue *> *args = [JSContext currentArguments];
//        NSString *elementName = [[args firstObject] toString];
//        Class c = [GICElementsCache classForElementName:elementName];
//        return [c new];
//    };
}

@end
