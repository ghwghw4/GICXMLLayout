//
//  GICTouchMoveEvent.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import "GICTouchMoveEvent.h"

@implementation GICTouchMoveEvent
+(NSString *)eventName{
    return @"touch-move";
}

-(GICCustomTouchEventMethodOverride)overrideType{
    return GICCustomTouchEventMethodOverrideTouchesMoved;
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    @weakify(self)
    [[target rac_signalForSelector:@selector(touchesMoved:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        if(self->isRejectEnum){
            [(_ASDisplayView *)target.view __forwardTouchesMoved:x[0] withEvent:x[1]];
        }
        @strongify(self)
        [self.eventSubject sendNext:x];
    }];
}
@end
