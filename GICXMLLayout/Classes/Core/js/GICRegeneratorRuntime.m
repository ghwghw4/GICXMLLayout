//
//  GICRegeneratorRuntime.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/27.
//

#import "GICRegeneratorRuntime.h"
#import "JSValue+GICJSExtension.h"


#pragma mark GICRegeneratorRuntimeContext

@protocol GICRegeneratorRuntimeContext <JSExport>
@property NSInteger prev;
@property NSInteger next;
@property JSValue *sent;

-(JSValue *)abrupt:(JSValue *)op :(JSValue *)value;
-(JSValue *)stop;
@end

@interface GICRegeneratorRuntimeContext : NSObject<GICRegeneratorRuntimeContext>{
    NSInteger _prev;
    NSInteger _next;
    JSManagedValue *sentManagedValue;
}
@property (nonatomic,assign)BOOL isDone;
@end

@implementation GICRegeneratorRuntimeContext
-(void)setPrev:(NSInteger)prev{
    _prev = prev;
}
-(NSInteger)prev { return _prev; }

-(void)setNext:(NSInteger)next{
    _next = next;
}

-(NSInteger)next { return _next; }

-(void)setSent:(JSValue *)sent{
    if(sent == nil || [sent isNull] || [sent isUndefined])
        sentManagedValue = nil;
    else
        sentManagedValue = [sent gic_ToManagedValue:sent];
}

-(JSValue *)sent{
    return sentManagedValue.value;
}

-(JSValue *)abrupt:(JSValue *)op :(JSValue *)value{
    self.isDone = YES;
    if([[op toString] isEqualToString:@"return"]){
        return value;
    }
    return [JSValue valueWithUndefinedInContext:[JSContext currentContext]];
}
-(JSValue *)stop{
    self.isDone = YES;
    return [JSValue valueWithUndefinedInContext:[JSContext currentContext]];
}
@end

#pragma mark GICRegeneratorRuntimeYield
@protocol GICRegeneratorRuntimeYield <JSExport>
-(JSValue *)next:(JSValue *)sent;
@end

@interface GICRegeneratorRuntimeYield : NSObject<GICRegeneratorRuntimeYield>{
    GICRegeneratorRuntimeContext *_context;
    JSManagedValue *callBackManagedValue;
    JSManagedValue *targetManagedValue;
}
@end

@implementation GICRegeneratorRuntimeYield
-(id)initWithCallBack:(JSValue *)callback withTarget:(JSValue *)target{
    self = [super init];
    callBackManagedValue = [callback gic_ToManagedValue:self];
    targetManagedValue = [target gic_ToManagedValue:self];
    _context = [[GICRegeneratorRuntimeContext alloc] init];
    return self;
}

-(JSValue *)next:(JSValue *)sent{
    JSValue *result = nil;
    _context.sent = sent;
    if(_context.isDone){
        result =[JSValue valueWithUndefinedInContext:[sent context]];
    }else{
        // 在target上执行回调
        result = [callBackManagedValue.value invokeMethod:@"call" withArguments:@[targetManagedValue.value,_context]];
    }
    _context.sent = nil;
    return [JSValue valueWithObject:@{@"value": result,@"done": @(_context.isDone)} inContext:[sent context]];
}
@end

#pragma mark GICRegeneratorRuntime
@implementation GICRegeneratorRuntime

+ (JSValue *)mark:(JSValue *)funcName {
    return funcName;
}

+ (id)wrap:(JSValue *)func :(JSValue *)markValue :(JSValue *)target {
    return [[GICRegeneratorRuntimeYield alloc] initWithCallBack:func withTarget:target];
}
@end
