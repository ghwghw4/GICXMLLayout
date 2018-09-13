//
//  GICScript.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/5.
//

#import "GICScript.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <GICJsonParser/GICJsonParser.h>
#import "GICJSElementValue.h"
#import "GICJSCore.h"
#import "GICStringConverter.h"

@interface GICScript(){
//    JSContext *context;
}
@end

@implementation GICScript

+(JSContext *)globalJSContentx{
    static JSContext *jsContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsContext = [JSContext new];
        jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"JSException: %@",exception);
        };
        // 注入GICJSCore
        [[GICJSCore shared] extend:jsContext];

    });
    return jsContext;
}

+(NSString *)gic_elementName{
    return @"script";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"func-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICScript *)target)->_functionName = value;
             }],
             };;
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    [super gic_beginParseElement:element withSuperElement:superElment];
    jsScript = [element stringValueOrginal];
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    
    id root = self.target;
    while (true) {
        id superEl = [root gic_getSuperElement];
        if(superEl==nil){
            break;
        }
        root = superEl;
    }
    
    [self addChildrenContext:root];
    
    JSValue *selfValue = [GICJSElementValue creatValueFrom:self.target toContext:[GICScript globalJSContentx]];
    NSString *funcName = self.functionName?:@"_Func_Script_";
    // 往selfValue 注入script 中定义的方法
    NSString *js = [NSString stringWithFormat:@"this.%@ = function () { %@ }",funcName,self->jsScript];
    [selfValue invokeMethod:@"executeScript" withArguments:@[js]];
    // 调用该方法，直接执行脚本
    [selfValue invokeMethod:funcName withArguments:nil];
}

-(void)addChildrenContext:(id)parent{
    for(id child in [parent gic_subElements]){
        [GICJSElementValue creatValueFrom:child toContext:[GICScript globalJSContentx]];
        [self addChildrenContext:child];
    }
}

@end
