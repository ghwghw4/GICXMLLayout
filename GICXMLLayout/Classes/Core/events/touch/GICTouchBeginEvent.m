//
//  GICTouchBeginEvent.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import "GICTouchBeginEvent.h"

@implementation GICTouchBeginEvent
-(GICCustomTouchEventMethodOverride)overrideType{
    return GICCustomTouchEventMethodOverrideTouchesBegan;
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    @weakify(self)
    [[target rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        if(self->isRejectEnum){
            [(_ASDisplayView *)target.view __forwardTouchesEnded:x[0] withEvent:x[1]];
        }
        @strongify(self)
        [self.eventSubject sendNext:x];
    }];
}
@end
