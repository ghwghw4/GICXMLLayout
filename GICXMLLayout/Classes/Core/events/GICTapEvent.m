//
//  GICClickeEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICTapEvent.h"

@implementation GICTapEvent
-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    @weakify(self)
    [target gic_get_tapSignal:^(RACSignal *signal) {
        [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.eventSubject sendNext:x];
        }];
    }];
}

-(void)unAttach{
    if([self.target isKindOfClass:[ASDisplayNode class]]){
        [self.target gic_safeView:^(UIView *view) {
            [view removeGestureRecognizer:self->tapges];
        }];
        tapges = nil;
    }
}
@end
