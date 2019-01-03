//
//  GICTouchMoveEvent.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import "GICTouchMoveEvent.h"

@implementation GICTouchMoveEvent
+(NSString *)eventName{
    return @"event-touch-move";
}

-(GICCustomTouchEventMethodOverride)overrideType{
    return GICCustomTouchEventMethodOverrideTouchesMoved;
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    // 为了解决RAC 的线程安全问题，只能强制调度到ElementQueue 线程上执行。以免在并发的时候会出现crash的问题。
    @weakify(self)
    GICPerformBlockOnElementQueue(^{
        [[target rac_signalForSelector:@selector(touchesMoved:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            if(self->isRejectEnum){
                [(_ASDisplayView *)((ASDisplayNode *)self.target).view __forwardTouchesMoved:x[0] withEvent:x[1]];
            }
            [self.eventSubject sendNext:[x[0] anyObject]];
        }];
    });
}
@end
