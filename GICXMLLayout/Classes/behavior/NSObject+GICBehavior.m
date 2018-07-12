//
//  NSObject+GICBehavior.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/12.
//

#import "NSObject+GICBehavior.h"
#import <objc/runtime.h>

@implementation NSObject (GICBehavior)
-(NSArray<GICBehavior *> *)gic_Behaviors{
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
    NSMutableArray<GICBehavior *> * temp= (NSMutableArray<GICBehavior *> *)self.gic_Behaviors;
    if(temp==nil){
        temp = [NSMutableArray array];
        objc_setAssociatedObject(self, "gic_Behaviors", temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [temp addObject:behavior];
    [behavior attachTo:self];
}
@end
