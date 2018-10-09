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
#import "GICBoolConverter.h"



@interface GICScript(){
//    JSContext *context;
    NSString *scriptPath;
}
@end

@implementation GICScript

+(NSString *)gic_elementName{
    return @"script";
}


+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"path":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICScript *)target)->scriptPath = value;
             }],
             @"private":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICScript *)target)->_isPrivate = [value boolValue];
             }],
             };;
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    [super gic_beginParseElement:element withSuperElement:superElment];
    jsScript = [element stringValueOrginal];
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    
    if(self->jsScript && self->jsScript.length>0){
        [self initJSScript:self->jsScript];
    }
    
    if(self->scriptPath){
        // TODO:暂时先采用同步加载，后面改成异步串行队列加载，需要由一个公共的加载器来实现。
        [self loadJSScript];
//        [self performSelectorInBackground:@selector(loadJSScript) withObject:nil];
    }
}

-(void)loadJSScript{
    NSData *jsData = [GICXMLLayout loadDataFromPath:self->scriptPath];
    NSString *jsStr = [[NSString alloc] initWithData:jsData encoding:4];
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self initJSScript:jsStr];
//    });
}

-(void)initJSScript:(NSString *)jsStr{
    if(!self.target){
        return;
    }
    JSContext *context = [GICJSCore findJSContextFromElement:self.target];
    if(self.isPrivate){
        JSValue *selfValue = [GICJSElementValue getJSValueFrom:self.target inContext:context];
        NSString *funcName = @"_Func_Script_";
        // 往selfValue 注入script 中定义的方法
        NSString *js = [NSString stringWithFormat:@"this.%@ = function () { %@ }",funcName,jsStr];
        [selfValue invokeMethod:@"executeScript" withArguments:@[js]];
        // 调用该方法，直接执行脚本
        [selfValue invokeMethod:funcName withArguments:nil];
    }else{
        [context evaluateScript:jsStr];
    }
}
@end
