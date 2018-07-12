//
//  GICClickeEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICTapEvent.h"
#import "GICView.h"

@implementation GICTapEvent
-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    if([target isKindOfClass:[ASDisplayNode class]]){
        tapges = [[UITapGestureRecognizer alloc] init];
        [target gic_safeView:^(UIView *view) {
            [view addGestureRecognizer:self->tapges];
        }];
        @weakify(self)
        [[tapges rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self)
//            if(x.state == UIGestureRecognizerStateEnded){
                [self.eventSubject sendNext:x];
//            }
        }];
    }
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
