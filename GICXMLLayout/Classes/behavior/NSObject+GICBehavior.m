//
//  NSObject+GICBehavior.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/12.
//

#import "NSObject+GICBehavior.h"
#import <objc/runtime.h>

@implementation NSObject (GICBehavior)
-(GICBehaviors *)gic_Behaviors{
    return objc_getAssociatedObject(self, "gic_Behaviors");
}

-(void)gic_addBehavior:(GICBehavior *)behavior{
    if(behavior.isOnce){
        [behavior attachTo:self];
        [behavior unattach];
        return;
    }
    if(behavior==nil)
        return;
    GICBehaviors * temp = self.gic_Behaviors;
    if(temp==nil){
        temp = [GICBehaviors new];
        objc_setAssociatedObject(self, "gic_Behaviors", temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [temp.behaviors addObject:behavior];
    [behavior attachTo:self];
}
@end
