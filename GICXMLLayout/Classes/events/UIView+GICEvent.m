//
//  UIView+GICEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "UIView+GICEvent.h"
#import <objc/runtime.h>

@implementation UIView (GICEvent)
-(NSArray<GICEvent *> *)gic_events{
    return objc_getAssociatedObject(self, "gic_events");
}

-(void)gic_event_addEvent:(GICEvent *)event{
    if(event==nil)
        return;
    NSMutableArray<GICEvent *> * dirs= (NSMutableArray<GICEvent *> *)self.gic_events;
    if(dirs==nil){
        dirs = [NSMutableArray array];
        objc_setAssociatedObject(self, "gic_events", dirs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [dirs addObject:event];
    [event onAttachTo:self];
}

//-(RACSignal *)gic_event_createTapEvent{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    [self addGestureRecognizer:tap];
//    return [tap rac_gestureSignal];
//}
@end
