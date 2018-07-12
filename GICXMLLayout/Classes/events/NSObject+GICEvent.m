//
//  NSObject+GICEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "NSObject+GICEvent.h"

@implementation NSObject (GICEvent)
-(GICEvent *)gic_event_addEvent:(GICEvent *)event{
    if(event.onlyExistOne){
        for(GICBehavior *b in self.gic_Behaviors.behaviors){
            if(b.class == event.class){
                return (GICEvent *)b;
            }
        }
    }
    [self gic_addBehavior:event];
    return event;
}
@end
