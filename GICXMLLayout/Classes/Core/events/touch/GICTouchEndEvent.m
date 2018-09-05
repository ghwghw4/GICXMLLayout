//
//  GICTouchEndEvent.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import "GICTouchEndEvent.h"

@implementation GICTouchEndEvent
+(NSString *)eventName{
    return @"touch-end";
}

-(GICCustomTouchEventMethodOverride)overrideType{
    return GICCustomTouchEventMethodOverrideTouchesEnded;
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    @weakify(self)
    [[target rac_signalForSelector:@selector(touchesEnded:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        if(self->isRejectEnum){
            [(_ASDisplayView *)target.view __forwardTouchesEnded:x[0] withEvent:x[1]];
        }
        @strongify(self)
        [self.eventSubject sendNext:x];
    }];
}
@end
