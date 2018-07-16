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

@implementation GICAnimation
+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return @{
             @"duration":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_duration = [value floatValue];
             }],
             @"repeat":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 NSInteger count = [value integerValue];
                 if(count==-1){
                     count = HUGE_VALF;
                 }
                 ((GICAnimation *)target)->_repeatCount = count;
             }],
             @"autoreverses":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_autoreverses = [value boolValue];
             }],
             @"on":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_triggerType = (GICAnimationTriggerType)[value integerValue];
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
    _target = target;
  
    if(self.triggerType == GICAnimationTriggerType_attach){
        [self beginAnimantion];
    }else if(self.triggerType == GICAnimationTriggerType_tap){
        @weakify(self)
        [target gic_get_tapSignal:^(RACSignal *signal) {
            [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self beginAnimantion];
            }];
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
    return nil;
}
@end
