//
//  GICEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICEvent.h"

@implementation GICEvent

-(id)initWithExpresion:(NSString *)expresion{
    self = [self init];
    _eventSubject = [RACSubject subject];
    expressionString = expresion;
    
    // 触发view-model的事件代理
    @weakify(self)
    [self.eventSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        SEL se = NSSelectorFromString(self->expressionString);
        id t = self.target;
        do {
            id vm = [t gic_DataContenxt];
            if([vm respondsToSelector:se]){
                GICEventInfo *eventInfo =[[GICEventInfo alloc] initWithTarget:self.target withValue:x];
                [vm performSelector:se withObject:eventInfo];
                break;
            }
            t = [t gic_getSuperElement];
        } while (t);
    }];
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
    self.target = target;
//    @weakify(self)
//    signlDisposable = [[self createEventSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self.eventSubject sendNext:x];
//    }];
}

-(void)unAttach{
    if(signlDisposable && ![signlDisposable isDisposed]){
        [signlDisposable dispose];
    }
}

//-(RACSignal *)createEventSignal{
//    return nil;
//}
@end
