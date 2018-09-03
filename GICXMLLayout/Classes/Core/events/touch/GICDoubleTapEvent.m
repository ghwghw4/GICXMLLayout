//
//  GICDoubleTapEvent.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import "GICDoubleTapEvent.h"

@implementation GICDoubleTapEvent
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
        if (touch.tapCount == 2) {
            NSLog(@"#tap");
            [self.eventSubject sendNext:touch];
        }
    }];
}
@end
