//
//  GICGCDTimer.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/12.
//

#import <Foundation/Foundation.h>

@interface GICGCDTimer : NSObject
+(instancetype)scheduledTimerWithTimeInterval:(uint64_t)interval block:(dispatch_block_t)block queue:(dispatch_queue_t)queue;
-(void)invalidate;
@end
