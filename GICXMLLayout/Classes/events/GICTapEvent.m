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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.target addGestureRecognizer:tap];
    return [tap rac_gestureSignal];
}
@end
