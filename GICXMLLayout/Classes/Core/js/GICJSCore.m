//
//  GICJSCore.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import "GICJSCore.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JSBase.h>
#import "GICJSAPIManager.h"
#import "JSContext+GICJSContext.h"
#import "GICJSToast.h"

@implementation NSObject (GICScript)
-(JSContext *)gic_JSContext{
    return objc_getAssociatedObject(self, "gic_JSContext");
}

-(void)setGic_JSContext:(JSContext *)jsContext{
    objc_setAssociatedObject(self, "gic_JSContext", jsContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@interface GICJSCore()
@end

@implementation GICJSCore
+(JSContext *)findJSContextFromElement:(NSObject *)element{
    JSContext *context = [element gic_JSContext];
    if(context){
        return context;
    }
    if([element isKindOfClass:[UIViewController class]] || [element gic_getSuperElement] == nil){
        context = [[JSContext alloc] init];
        // 注入GICJSCore
        [self extend:context rootElement:element];
        [element setGic_JSContext:context];
        return context;
    }
    return [self findJSContextFromElement:[element gic_getSuperElement]];
}

+(void)extend:(JSContext *)context {
    [self extend:context rootElement:nil];
}

+(void)extend:(JSContext *)context rootElement:(id)rootElement{
    [context registCoreAPI];
    if(rootElement)
    [context setRootElement:[[GICJSElementDelegate getJSValueFrom:rootElement inContext:context] toObject]];
    context[@"Toast"] = [GICJSToast class];
    [GICJSAPIManager initJSContext:context];
}

+(void)shareJSContext:(id)fromElement to:(id)toElement{
    JSContext *context = [GICJSCore findJSContextFromElement:fromElement];
    [toElement setGic_JSContext:context];
}
@end

