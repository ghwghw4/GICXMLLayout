//
//  GICClickeEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICTapEvent.h"
#import <objc/runtime.h>
//#import <ASDisplayNodeInternal.h>

@implementation GICTapEvent
+(NSString *)eventName{
    return @"event-tap";
}

-(GICCustomTouchEventMethodOverride)overrideType{
    return GICCustomTouchEventMethodOverrideTouchesEnded;
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    
    // 为了解决RAC 的线程安全问题，只能强制调度到ElementQueue 线程上执行。以免在并发的时候会出现crash的问题。
    @weakify(self)
    [GICTapEvent performThreadSafe:^{
        [[target rac_signalForSelector:@selector(touchesEnded:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
            NSSet *touches = x[0];
            UITouch *touch = [touches anyObject];
            @strongify(self)
            if (touch.tapCount == 1) {
                if(self->isRejectEnum)
                    [(_ASDisplayView *)((ASDisplayNode *)self.target).view __forwardTouchesEnded:x[0] withEvent:x[1]];
                [self.eventSubject sendNext:touch];
            }
        }];
    }];
}
@end
