//
//  GICScript.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/5.
//

#import "GICScript.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <GICJsonParser/GICJsonParser.h>
#import "JSValue+GICJSExtension.h"
#import "GICJSCore.h"
#import "GICStringConverter.h"
#import "GICBoolConverter.h"
#import "GICXMLParserContext.h"
#import "GICJSElementDelegate.h"
#import "JSContext+GICJSContext.h"

@interface GICScript(){
    //    JSContext *context;
    NSString *scriptPath;
}
@end

@implementation GICScript

static NSMutableArray<NSOperation *> *operationArray;
+(void)initialize{
    operationArray = [NSMutableArray array];
}

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

-(id)init{
    self = [super init];
    if([GICXMLParserContext currentInstance]){
        @weakify(self)
        [operationArray addObject:[NSBlockOperation blockOperationWithBlock:^{
            @strongify(self)
            [self invokeJSScript];
        }]];
    }
    [[GICXMLParserContext currentInstance].parseCompeteSubject subscribeCompleted:^{
        if(operationArray.count>0){
            NSArray *copyArr=[operationArray copy];
            [operationArray removeAllObjects];
            NSOperationQueue *queue = [NSOperationQueue mainQueue];
            [copyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [queue addOperation:obj];
            }];
        }
    }];
    return self;
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    // 确保JSContext 正确初始化
    if(![GICXMLParserContext currentInstance]){
        [self invokeJSScript];
    }
}

-(void)invokeJSScript{
    if(self->jsScript && self->jsScript.length>0){
        [self initJSScript:self->jsScript];
    }
    if(self->scriptPath){
        // TODO:暂时先采用同步加载，后面改成异步串行队列加载，需要由一个公共的加载器来实现。
        [self loadJSScript];
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
        JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self.target inContext:context];
        if([context isSetRootDataContext]){
            NSString *js = [NSString stringWithFormat:@"var $el = arguments[0]; %@;",jsStr];
            [[context rootDataContext] excuteJSString:js withArguments:@[selfValue]];
        }else{
            NSString *js = [NSString stringWithFormat:@"var $el = %@; %@; delete $el;", [(GICJSElementDelegate *)selfValue.toObject variableName],jsStr];
            [context evaluateScript:js];
        }
    }else{
        [context evaluateScript:jsStr];
    }
}
@end
