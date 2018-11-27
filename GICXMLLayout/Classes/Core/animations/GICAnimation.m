//
//  GICAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICAnimation.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICBoolConverter.h"
#import "NSObject+GICEvent.h"
#import "GICTapEvent.h"

@implementation GICAnimation
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"duration":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_duration = [value floatValue];
             }],
             @"repeat":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 NSInteger count = [value integerValue];
                 ((GICAnimation *)target)->_repeatCount = count;
             }],
             @"autoreverses":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_autoreverses = [value boolValue];
             }],
             @"on":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_triggerType = (GICAnimationTriggerType)[value integerValue];
             }],
             @"event-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_eventName = value;
             }],
             @"ease-mode":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_easeMode = (GICAnimationEaseMode)[value integerValue];
             }],
//             @"spring-velocity":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 // spring动画初始速率
//                 ((GICAnimation *)target)->_springVelocity = [value floatValue];
//             }],
             @"spring-bounciness":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 // spring动画
                 ((GICAnimation *)target)->_springBounciness = [value floatValue];
             }],
             @"spring-speed":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 // spring动画速度
                 ((GICAnimation *)target)->_springSpeed = [value floatValue];
             }],
             };;
}

-(id)init{
    self  = [super init];
    _duration = 0.5;//默认0.5秒
    animationKey = [GICUtils uuidString];
    _springBounciness = -1.0f;
    _springSpeed = -1.0f;
    return self;
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    if(self.triggerType == GICAnimationTriggerType_attach){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginAnimantion];
        });
    }else if(self.triggerType == GICAnimationTriggerType_event){
        @weakify(self)
        GICEvent *event = nil;
        if(self.eventName){
            event = [target gic_event_findFirstWithEventNameOrCreate:self.eventName];
        }else{
            event = [target gic_event_findFirstWithEventClassOrCreate:[GICTapEvent class]];
        }
        [event.eventSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self beginAnimantion];
        }];
    }
}

-(void)beginAnimantion{
    [self pop_removeAnimationForKey:animationKey];
    POPAnimation *animation = [self createAnimation];
    animation.repeatCount = self.repeatCount == -1?HUGE_VAL:self.repeatCount;
    animation.autoreverses = self.autoreverses;
    [self.target pop_addAnimation:animation forKey:nil];
}

-(POPPropertyAnimation *)createAnimation{
    POPPropertyAnimation *propAnim = nil;
    if(self.springBounciness >= 0 || self.springSpeed >= 0){
        propAnim = [POPSpringAnimation animation];
        if(self.springSpeed >= 0){
            [(POPSpringAnimation *)propAnim setSpringSpeed:self.springSpeed];
        }
        
//        if(self.springVelocity>0){
//            [(POPSpringAnimation *)propAnim setVelocity:@(self.springVelocity)];
//        }
       
        if(self.springBounciness >= 0){
            [(POPSpringAnimation *)propAnim setSpringBounciness:self.springBounciness];
        }
    }else{
        propAnim = [POPBasicAnimation linearAnimation];
        [(POPBasicAnimation *)propAnim setDuration:self.duration];
        switch (self.easeMode) {
            case GICAnimationEaseMode_EaseIn:
                ((POPBasicAnimation *)propAnim).timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                break;
            case GICAnimationEaseMode_EaseOut:
                ((POPBasicAnimation *)propAnim).timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                break;
            case GICAnimationEaseMode_EaseInEaseOut:
                ((POPBasicAnimation *)propAnim).timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                break;
            default:
                break;
        }
    }
    propAnim.property = [self createAnimatableProperty];    //自定义属性
    propAnim.fromValue = @(0);
    propAnim.toValue = @(100);
    return propAnim;
}

-(POPAnimatableProperty *)createAnimatableProperty{
    return nil;
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}
@end

