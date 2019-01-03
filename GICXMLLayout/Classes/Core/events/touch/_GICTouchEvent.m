//
//  _GICTouchEvent.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import "_GICTouchEvent.h"

@implementation _GICTouchEvent
static dispatch_queue_t queue;
+(void)initialize{
    queue = dispatch_queue_create("rac thread safe queue", NULL);
}
-(BOOL)onlyExistOne{
    return YES;
}
-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    
    // 获取_methodOverrides私有变量
    Ivar ivar = class_getInstanceVariable([target class], "_methodOverrides");
    if(!ivar){
        return;
    }
    //对应ASDisplayNodeMethodOverrideTouchesEnded枚举
    id  value =  [target valueForKey:@"methodOverrides"];
    unsigned long long _methodOverrides = [value longLongValue];
    if(!(_methodOverrides & self.overrideType)){
        _methodOverrides |= self.overrideType;
        isRejectEnum = YES;
        ((void (*)(id, Ivar, long long))object_setIvar)(target, ivar, _methodOverrides);
    }
    [target setUserInteractionEnabled:YES];
    
//    @weakify(self)
//    [[target rac_signalForSelector:@selector(touchesEnded:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
//        NSSet *touches = x[0];
//        UITouch *touch = [touches anyObject];
//        @strongify(self)
//        if (touch.tapCount == 1) {
//            NSLog(@"#tap");
//            [self.eventSubject sendNext:nil];
//        }
//    }];
}

+(void)performThreadSafe:(dispatch_block_t)block{
    dispatch_async(queue, block);
}
@end
