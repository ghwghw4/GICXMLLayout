//
//  UIView+GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <UIKit/UIKit.h>
#import "GICEvent.h"

@interface NSObject (GICEvent)
@property (nonatomic,strong,readonly)NSArray<GICEvent *> *gic_events;
-(void)gic_event_addEvent:(GICEvent *)event;

///**
// 创建一个tap事件
//
// @return <#return value description#>
// */
//-(RACSignal *)gic_event_createTapEvent;
@end
