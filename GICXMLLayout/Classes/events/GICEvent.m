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
    return self;
}

-(void)onAttachTo:(id)target{
    self.target = target;
    @weakify(self)
    [[self createEventSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.eventSubject sendNext:x];
    }];
    
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
}

-(RACSignal *)createEventSignal{
    return nil;
}
@end
