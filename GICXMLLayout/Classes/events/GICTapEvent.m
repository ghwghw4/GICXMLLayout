//
//  GICClickeEvent.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICTapEvent.h"
//#import "UIView+GICEvent.h"

@implementation GICTapEvent
-(RACSignal *)createEventSignal{
    if([self.target isKindOfClass:[UIView class]]){
        tapges = [[UITapGestureRecognizer alloc] init];
        [self.target addGestureRecognizer:tapges];
        return [tapges rac_gestureSignal];
    }
    return nil;
}

-(void)unAttach{
    if([self.target isKindOfClass:[UIView class]]){
        [self.target removeGestureRecognizer:tapges];
        tapges = nil;
    }
}
@end
