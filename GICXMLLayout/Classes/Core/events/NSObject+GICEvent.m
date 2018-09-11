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

-(GICEvent *)gic_event_findFirstWithEventClass:(Class)eventType{
    GICBehavior *b = [self.gic_Behaviors findFirstWithBehaviorClass:eventType];
    if([b isKindOfClass:[GICEvent class]]){
        return (GICEvent *)b;
    }
    return nil;
}

-(GICEvent *)gic_event_findFirstWithEventClassOrCreate:(Class)eventType{
    GICEvent *e = [self gic_event_findFirstWithEventClass:eventType];
    if(e==nil){
        e = [[eventType alloc] initWithExpresion:nil withEventName:nil];
        [self gic_event_addEvent:e];
        if(e.target==nil){
            [e attachTo:self];
        }
    }
    return e;
}

-(GICEvent *)gic_event_findWithEventName:(NSString *)eventName{
    GICBehavior *b = [self.gic_Behaviors findWithBehaviorName:eventName];
    if([b isKindOfClass:[GICEvent class]]){
        return (GICEvent *)b;
    }
    return nil;
}

-(GICEvent *)gic_event_findFirstWithEventNameOrCreate:(NSString *)eventName{
    GICEvent *e = [self gic_event_findWithEventName:eventName];
    if(e==nil){
        GICAttributeValueConverter *p =  [GICElementsCache classAttributs:[self class]][eventName];
        if(p){
            p.propertySetter(self, nil);
            e = [self gic_event_findWithEventName:eventName];
            [self gic_event_addEvent:e];
            if(e.target==nil){
                [e attachTo:self];
            }
        }
    }
    
    return e;
}
@end
