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
                 ((GICAnimation *)target)->_repeatCount = (count==-1?HUGE_VAL:count);
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
             };;
}

-(id)init{
    self  = [super init];
    _duration = 0.5;//默认0.5秒
    animationKey = [GICUtils uuidString];
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
    if([animation respondsToSelector:@selector(setDuration:)]){
        [animation performSelector:@selector(setDuration:) withObject:@(self.duration)];
    }
    animation.repeatCount = self.repeatCount;
    animation.autoreverses = self.autoreverses;
    [self.target pop_addAnimation:animation forKey:nil];
}

-(POPPropertyAnimation *)createAnimation{
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];
    anBasic.property = [self createAnimatableProperty];    //自定义属性
    anBasic.fromValue = @(0);
    anBasic.toValue = @(100);
    switch (self.easeMode) {
        case GICAnimationEaseMode_EaseIn:
            anBasic.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            break;
        case GICAnimationEaseMode_EaseOut:
            anBasic.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            break;
        case GICAnimationEaseMode_EaseInEaseOut:
            anBasic.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            break;
            
        default:
            break;
    }
    return anBasic;
}

-(POPAnimatableProperty *)createAnimatableProperty{
    return nil;
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}
@end
