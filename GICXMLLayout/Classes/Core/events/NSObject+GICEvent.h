//
//  NSObject+GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <Foundation/Foundation.h>
#import "GICEvent.h"
@interface NSObject (GICEvent)
-(GICEvent *)gic_event_addEvent:(GICEvent *)event;
-(GICEvent *)gic_event_findFirstWithEventClass:(Class)eventType;
-(GICEvent *)gic_event_findWithEventName:(NSString *)eventName;

-(GICEvent *)gic_event_findFirstWithEventClassOrCreate:(Class)eventType;
-(GICEvent *)gic_event_findFirstWithEventNameOrCreate:(NSString *)eventName;
@end
