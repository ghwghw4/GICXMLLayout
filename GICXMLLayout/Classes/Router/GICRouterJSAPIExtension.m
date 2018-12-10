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

static id gic_tempparamsValue = nil;

@protocol GICJSRouter <JSExport>
@required
/**
 返回上一页
 */
-(void)goBack:(JSValue *)paramsData;

// 返回跟目录
-(void)goBackRoot;

-(void)goBackWithCount:(NSInteger)count;

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
    gic_tempparamsValue = __convertJSValueToJsonString(paramsData,[JSContext currentContext]);
    [[element gic_Router] goBackWithParams:nil];
}

-(void)goBackRoot{
    [[element gic_Router] goBack:-1];
}

-(void)goBackWithCount:(NSInteger)count{
    [[element gic_Router] goBack:count];
}

- (void)push:(NSString *)path withParamsData:(JSValue *)paramsData {
    gic_tempparamsValue = __convertJSValueToJsonString(paramsData,[JSContext currentContext]);
    [[element gic_Router] push:path withParamsData:nil];
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
    if(gic_tempparamsValue){
        context[@"Router"][@"params"] = __convertPramsDataToJsonData(gic_tempparamsValue,context);
        gic_tempparamsValue = nil;
    }
}

//+(void)setJSParamsData:(id)paramsData withPage:(GICPage *)page{
//    JSContext *context = [GICJSCore findJSContextFromElement:page];
//    context[@"Router"][@"params"] = __convertPramsDataToJsonData(paramsData,context);
//}

+(void)goBackFromPage:(GICPage *)page{
    if(gic_tempparamsValue){
        JSContext *context = [GICJSCore findJSContextFromElement:page];
        [context[@"Router"][@"onNavgateBackFrom"] callWithArguments:(@[__convertPramsDataToJsonData(gic_tempparamsValue,context)])];
    }
}
@end
