//
//  GICGCDTimer.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/12.
//

#import "GICGCDTimer.h"

@implementation GICGCDTimer{
    dispatch_source_t timer;
}
+(instancetype)scheduledTimerWithTimeInterval:(uint64_t)interval block:(dispatch_block_t)block queue:(dispatch_queue_t)queue{
    return [[GICGCDTimer alloc] initWithInterval:interval block:block queue:queue];
}

-(id)initWithInterval:(uint64_t)interval block:(dispatch_block_t)block queue:(dispatch_queue_t)queue{
    self = [self init];
    timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, interval), interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(timer, block);
    // 启动定时器
    dispatch_resume(timer);
    return self;
}

-(void)invalidate{
    dispatch_source_cancel(timer);
}

-(void)dealloc{
    [self invalidate];
}
@end
