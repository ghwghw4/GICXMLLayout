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
    NSObject *superEl = [element gic_getSuperElement];
    if(superEl == nil){
        context = [[JSContext alloc] init];
        // 注入GICJSCore
        [self extend:context];
         [context setRootElement:[[GICJSElementDelegate getJSValueFrom:element inContext:context] toObject]];
        [element setGic_JSContext:context];
        return context;
    }
    return [self findJSContextFromElement:superEl];
}

+(void)extend:(JSContext *)context {
    [context registCoreAPI];
    [GICJSAPIManager initJSContext:context];
}
@end
