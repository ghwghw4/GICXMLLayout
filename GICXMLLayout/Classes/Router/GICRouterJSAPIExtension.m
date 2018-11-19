//
//  GICRouterJSAPIExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/17.
//

#import "GICRouterJSAPIExtension.h"
#import "NSObject+GICRouter.h"
#import "GICJSCore.h"
#import "GICJSPopover.h"
#import "GICJSDocument.h"
#import "JSValue+GICJSExtension.h"

// 由于两个JScontext 无法共享JSvalue ，因此需要将JSValue 序列化成JSON string，然后再反序列化回来
id __convertPramsDataToJsonData(id paramsData,JSContext *context){
    if(paramsData == nil)
        return nil;
    id params = paramsData;
    if([paramsData isKindOfClass:[NSString class]]){
        JSValue *result = [context.globalObject excuteJSString:@"try {return JSON.parse(arguments[0]) }catch (e){} " withArguments:@[paramsData]];
        if(![result isUndefined]){
            params = result;
        }
    }
    return params;
}

id __convertJSValueToJsonString(JSValue *paramsData,JSContext *context){
    if(paramsData==nil)
        return nil;
    id params = [paramsData toObject];
    if(paramsData.isObject || paramsData.gic_isArray){
        JSValue *result = [context.globalObject excuteJSString:@" try { return JSON.stringify(arguments[0]) }catch (e){}" withArguments:@[paramsData]];
        if(![result isUndefined]){
            params = [result toString];
        }
    }
    return params;
}

@protocol GICJSRouter <JSExport>
@required
/**
 返回上一页
 */
-(void)goBack:(JSValue *)paramsData;

/**
 根据path导航到下一页,并且带有参数。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path <#path description#>
 @param paramsData <#paramsData description#>
 */
JSExportAs(push, -(void)push:(NSString *)path withParamsData:(JSValue *)paramsData);

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

-(void)goBack:(JSValue *)paramsData{
    [[element gic_Router] goBackWithParams:__convertJSValueToJsonString(paramsData,[JSContext currentContext])];
}

- (void)push:(NSString *)path withParamsData:(JSValue *)paramsData {
    [[element gic_Router] push:path withParamsData:__convertJSValueToJsonString(paramsData,[JSContext currentContext])];
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
    context[@"Router"] = [[GICJSRouter alloc] initWithElement:[GICJSDocument rootElementFromJsContext:context]];
    context[@"Popover"] = [GICJSPopover class];
}

+(void)setJSParamsData:(id)paramsData withPage:(GICPage *)page{
    JSContext *context = [GICJSCore findJSContextFromElement:page];
    context[@"Router"][@"params"] = __convertPramsDataToJsonData(paramsData,context);
}

+(void)goBackWithParmas:(id)paramsData fromPage:(GICPage *)page{
    JSContext *context = [GICJSCore findJSContextFromElement:page];
    [context[@"Router"][@"onNavgateBackFrom"] callWithArguments:(paramsData?@[__convertPramsDataToJsonData(paramsData,context)]:nil)];
}
@end
