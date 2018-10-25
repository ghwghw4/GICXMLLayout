//
//  GICJSNativeAPI.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/19.
//

#import "GICJSNativeAPI.h"

@implementation GICJSNativeAPI
static id createNativeObject(NSString *className){
    Class cls = NSClassFromString(className);
    if(cls){
        id obj = [cls alloc];
        return obj;
    }
    return nil;
}

static id gic_resolveInvocationReturnValue(NSInvocation *invocation){
    // 获取返回值
    const char * returnValueType = invocation.methodSignature.methodReturnType;
  
    if (!strcmp(returnValueType, @encode(void))) {// 没有返回值
        return nil;
    }else{
        id obj = nil;
        /**
         这里必须使用void *来保存value，否则会引起crashs.因为这里涉及到在ARC模式下的内存管理的问题。
         原因是在arc模式下，getReturnValue：仅仅是从invocation的返回值拷贝到指定的内存地址，如果返回值是一个NSObject对象的话，是没有处理起内存管理的。而我们在定义returnValue时使用的是__strong类型的指针对象，arc就会假设该内存块已被retain（实际没有），当resultSet出了定义域释放时，导致该crash。假如在定义之前有赋值的话，还会造成内存泄露的问题。
         使用void *来保存变量的话，arc就不会对returnValue进行release操作
         */
        void *returnValue = nil;
        [invocation getReturnValue: &returnValue];
        if(returnValue)
            obj = (__bridge id)returnValue;
        // 将返回的对象转换成js 对象，并且添加预先定义的属性方法
        NSString *className = NSStringFromClass([obj class]);
        if(![[JSContext currentContext][className] isUndefined]){
            obj = [JSValue valueWithObject:obj inContext:[JSContext currentContext]];
            JSValue *f = [JSContext currentContext][@"_ApplyClassMetaInfoToNativeObject"];
            [f callWithArguments:@[obj,className]];
        }
        return obj;
    }
}

-(JSValue *)defineClass:(NSString *)className{
    JSContext *context = [JSContext currentContext];
    JSValue *clsValue = context[className];
    if([clsValue isUndefined]){
        Class cls = NSClassFromString(className);
        if(!cls)
            return nil;
        context[className] = ^id(){
           return [[JSContext currentContext] evaluateScript:[NSString stringWithFormat:@"_GICCreateObject('%@');",className]];
        };
        clsValue = context[className];
        clsValue[@"cls"] = className;
        clsValue[@"_isNative"] = @(1);
    }
    return clsValue;
}

-(id)createObject:(NSString *)className arguments:(NSArray<JSValue *>*)arguments{
    return createNativeObject(className);
}

-(id)callMethod:(id)object methodName:(NSString *)methodName arguments:(NSArray*)arguments{
    SEL selector = NSSelectorFromString(methodName);
    if([object respondsToSelector:selector]){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [[object class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:object];
        
        // 设置参数
        for(int i=2;i<invocation.methodSignature.numberOfArguments;i++){
            if(arguments.count>i-2){
                id value = arguments[i-2];
                if([value isKindOfClass:[JSValue class]]){
                    id arg = [(JSValue *)value toObject];
                    [invocation setArgument:&arg atIndex:i];
                }else{
                    [invocation setArgument:&value atIndex:i];
                }
            }
        }
        [invocation invoke];
        return gic_resolveInvocationReturnValue(invocation);
    }
    return nil;
}

-(id)callMethodStatic:(NSString *)className methodName:(NSString *)methodName arguments:(NSArray*)arguments{
    Class cls = NSClassFromString(className);
    if(!cls)
        return nil;
    
    SEL selector = NSSelectorFromString(methodName);
    NSMethodSignature *sig = [cls methodSignatureForSelector:selector];
    if(sig){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:selector];
        [invocation setTarget:cls];
        
        // 设置参数
        for(int i=2;i<invocation.methodSignature.numberOfArguments;i++){
            if(arguments.count>i-2){
                id value = arguments[i-2];
                if([value isKindOfClass:[JSValue class]]){
                    id arg = [(JSValue *)value toObject];
                    [invocation setArgument:&arg atIndex:i];
                }else{
                    [invocation setArgument:&value atIndex:i];
                }
            }
        }
        [invocation invoke];
        return gic_resolveInvocationReturnValue(invocation);
    }
    return nil;
}

-(void)setProperty:(id)object propertyName:(NSString *)propertyName value:(id)value{
    [object setValue:value forKey:propertyName];
}
@end
