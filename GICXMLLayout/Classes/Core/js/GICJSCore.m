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

@implementation GICJSCore
+(instancetype)shared
{
    static dispatch_once_t pred;
    static GICJSCore* sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[GICJSCore alloc] init];
    });
    return sharedInstance;
}

-(void)extend:(JSContext *)context { return [self extend:context logHandler:nil]; }
-(void)extend:(JSContext*)context logHandler:(void (^)(NSString*,NSArray*,NSString*))logHandler;
{
    NSString *jsCoreString = [NSBundle gic_jsCoreString];
    [context evaluateScript:jsCoreString];
    
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
    
    
//    context[@"createElement"] = ^{
//        NSArray<JSValue *> *args = [JSContext currentArguments];
//        NSString *elementName = [[args firstObject] toString];
//        Class c = [GICElementsCache classForElementName:elementName];
//        return [c new];
//    };
}

@end
