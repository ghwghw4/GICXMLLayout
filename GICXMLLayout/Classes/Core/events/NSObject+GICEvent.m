//
//  NSObject+GICEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "NSObject+GICEvent.h"

@implementation NSObject (GICEvent)
-(GICEvent *)gic_event_addEvent:(GICEvent *)event{
    if(event.onlyExistOne){
        for(GICBehavior *b in self.gic_Behaviors.behaviors){
            if(b.class == event.class){
                return (GICEvent *)b;
            }
        }
    }
    [self gic_addBehavior:event];
    return event;
}

-(void)gic_get_tapSignal:(void (^)(RACSignal *signal))cb{
    if([self isKindOfClass:[ASDisplayNode class]]){
        ASDisplayNode *node = (ASDisplayNode *)self;
        node.userInteractionEnabled = YES;
        [node gic_safeView:^(UIView *view) {
            UITapGestureRecognizer *tapges = nil;
            for(UIGestureRecognizer *ges in view.gestureRecognizers){
                if([ges isKindOfClass:[UITapGestureRecognizer class]]){
                    tapges = (UITapGestureRecognizer *)ges;
                    break;
                }
            }
            if(tapges == nil){
                tapges = [[UITapGestureRecognizer alloc] init];
                [view addGestureRecognizer:tapges];
            }
            cb([tapges rac_gestureSignal]);
        }];
    }
}
@end
