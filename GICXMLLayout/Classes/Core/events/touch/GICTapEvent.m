//
//  GICClickeEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICTapEvent.h"
#import <objc/runtime.h>
//#import <ASDisplayNodeInternal.h>

@implementation GICTapEvent
-(GICCustomTouchEventMethodOverride)overrideType{
    return GICCustomTouchEventMethodOverrideTouchesEnded;
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    
    @weakify(self)
    [[target rac_signalForSelector:@selector(touchesEnded:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        if(self->isRejectEnum)
            [(_ASDisplayView *)target.view __forwardTouchesEnded:x[0] withEvent:x[1]];
        NSSet *touches = x[0];
        UITouch *touch = [touches anyObject];
        @strongify(self)
        if (touch.tapCount == 1) {
            [self.eventSubject sendNext:touch];
        }
    }];
}
@end
