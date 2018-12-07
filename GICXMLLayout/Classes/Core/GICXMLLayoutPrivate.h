//
//  GICXMLLayoutPrivate.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/31.
//

#ifndef GICXMLLayoutPrivate_h
#define GICXMLLayoutPrivate_h
#import "GICXMLLayout.h"
@interface GICXMLLayout (Private)
+(BOOL)enableDefualtStyle;
+(dispatch_queue_t)parseElementQueue;
@end

// 调度到ElementQueue 同步执行
void GICPerformBlockOnElementQueue(void (^block)(void));

#endif /* GICXMLLayoutPrivate_h */
