//
//  GICRouterJSAPIExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/17.
//

#import "GICRouterJSAPIExtension.h"
#import "NSObject+GICRouter.h"
#import "GICJSCore.h"

@protocol GICJSRouter <JSExport>
@required
/**
 返回上一页
 */
-(void)goBack:(id)paramsData;

/**
 根据path导航到下一页,并且带有参数。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path <#path description#>
 @param paramsData <#paramsData description#>
 */
JSExportAs(push, -(void)push:(NSString *)path withParamsData:(id)paramsData);

/**
 导航参数
 */
@property JSValue* params;

@property JSValue* onNavgateBackFrom;
@end

@interface GICJSRouter : NSObject<GICJSRouter>{
    __weak id element;
    JSManagedValue *managedJSValue;
    JSManagedValue *managedOnNavgateBackFrom;
}
@end

@implementation GICJSRouter
-(id)initWithElement:(id)element{
    self = [self init];
    self->element = element;
    return self;
}

-(void)goBack:(id)paramsData{
    [[element gic_Router] goBackWithParams:paramsData];
}

- (void)push:(NSString *)path withParamsData:(id)paramsData {
    [[element gic_Router] push:path withParamsData:paramsData];
}

-(void)setParams:(JSValue *)params{
    managedJSValue = [JSManagedValue managedValueWithValue:params];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedJSValue withOwner:self];
}

-(JSValue *)params{
    return managedJSValue.value;
}

-(void)setOnNavgateBackFrom:(JSValue *)onNavgateBackFrom{
    managedOnNavgateBackFrom = [JSManagedValue managedValueWithValue:onNavgateBackFrom];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedOnNavgateBackFrom withOwner:self];
}

-(JSValue *)onNavgateBackFrom{
    return managedOnNavgateBackFrom.value;
}
@end


@implementation GICRouterJSAPIExtension
+(void)registeJSAPIToJSContext:(JSContext *)context{
    JSValue *jsvalue = context[@"document"]; //[context evaluateScript:@"return document._getRootElement();"];
    if(![jsvalue isUndefined]){
        jsvalue = [jsvalue invokeMethod:@"_getRootElement" withArguments:nil];
        context[@"Router"] = [[GICJSRouter alloc] initWithElement:[jsvalue toObject]];
    }
}

+(void)setJSParamsData:(id)paramsData withPage:(GICPage *)page{
    JSContext *context = [GICJSCore findJSContextFromElement:page];
    context[@"Router"][@"params"] = paramsData;
}

+(void)goBackWithParmas:(id)paramsData fromPage:(GICPage *)page{
    JSContext *context = [GICJSCore findJSContextFromElement:page];
    [context[@"Router"][@"onNavgateBackFrom"] callWithArguments:@[paramsData]];
}
@end
