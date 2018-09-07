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

@interface GICScript(){
    JSContext *context;
}
@end

@implementation GICScript
+(NSString *)gic_elementName{
    return @"script";
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    jsScript = [element stringValueOrginal];
    [super gic_beginParseElement:element withSuperElement:superElment];
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JSException: %@",exception);
    };

    // 注入GICJSCore
    [[GICJSCore shared] extend:context];
    
    id root = self.target;
    while (true) {
        id superEl = [root gic_getSuperElement];
        if(superEl==nil){
            break;
        }
        root = superEl;
    }
    
    [self addChildrenContext:root];
     [GICJSElementValue creatValueFrom:self.target toContext:context];
    NSString *name=[target gic_ExtensionProperties].name;
    NSString *js = [NSString stringWithFormat:@"function _tempFunc() { %@ } _tempFunc.apply(%@);",self->jsScript,name];
    [context evaluateScript:js];
}

-(void)addChildrenContext:(id)parent{
    for(id child in [parent gic_subElements]){
        [GICJSElementValue creatValueFrom:child toContext:context];
        [self addChildrenContext:child];
    }
}

@end
