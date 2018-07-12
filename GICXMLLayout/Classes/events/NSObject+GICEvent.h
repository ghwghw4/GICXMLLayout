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
@end
