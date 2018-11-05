//
//  GICEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICEvent.h"
#import "GICDataContext+JavaScriptExtension.h"

@implementation GICEvent
+(instancetype)createEventWithExpresion:(NSString *)expresion withEventName:(NSString *)eventName toTarget:(id)target{
    GICEvent *e = [[[self class] alloc] initWithExpresion:expresion withEventName:eventName];
    [target gic_event_addEvent:e];
    return e;
}

+(instancetype)createEventWithExpresion:(NSString *)expresion toTarget:(id)target{
    return [self createEventWithExpresion:expresion withEventName:[self eventName] toTarget:target];
}

-(id)init{
    NSAssert(false, @"请使用initWithExpresion来初始化");
    return nil;
}

-(id)initWithExpresion:(NSString *)expresion withEventName:(NSString *)eventName{
    self = [super init];
    _eventSubject = [RACSubject subject];
    expressionString = expresion;
    
    // 触发view-model的事件代理
    @weakify(self)
    [self.eventSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        // 先判断是否是js调用
        if([self->expressionString hasPrefix:@"js:"]){
            // 兼容js的调用
            NSString *js = [self->expressionString substringWithRange:NSMakeRange(3, self->expressionString.length-3)];
            [self excuteJSBindExpress:js withValue:x];
        }else{
            SEL se = NSSelectorFromString(self->expressionString);
            if(se){
                id t = self.target;
                do {
                    id vm = [t gic_DataContext];
                    if([vm respondsToSelector:se]){
                        GICEventInfo *eventInfo =[[GICEventInfo alloc] initWithTarget:self.target withValue:x];
                        [vm performSelector:se withObject:eventInfo];
                        break;
                    }
                    t = [t gic_getSuperElement];
                } while (t);
            }
        }
    }];
    self.name = eventName;
    return self;
}

-(id)initWithExpresion:(NSString *)expresion{
    self = [self initWithExpresion:expresion withEventName:nil];
    return self;
}

-(BOOL)isOnlyExistOne{
    return YES;
}

-(void)attachTo:(id)target{
    if(self.target){
        // 先取消绑定
        [self  unAttach];
    }
    [super attachTo:target];
}

-(void)unAttach{
//    if(signlDisposable && ![signlDisposable isDisposed]){
//        [signlDisposable dispose];
//    }
}

-(void)fire:(id)value{
    [self.eventSubject sendNext:value];
}

-(void)dealloc{
    [_eventSubject sendCompleted];
}

+(NSString *)eventName{
    return nil;
}
@end
