//
//  GICAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import <GICXMLLayout/GICXMLLayout.h>
#import <pop/POP.h>

typedef enum {
    GICAnimationTriggerType_None = 0 ,//不触发
    GICAnimationTriggerType_attach = 1,//附加的时候
    GICAnimationTriggerType_event = 2//事件触发，默认tab事件
}GICAnimationTriggerType;

typedef enum {
    GICAnimationEaseMode_Linear = 0 ,//线性动画
    GICAnimationEaseMode_EaseIn = 1,//
    GICAnimationEaseMode_EaseOut = 2,//
    GICAnimationEaseMode_EaseInEaseOut = 3//
}GICAnimationEaseMode;


/**
 动画基类，
 当springBounciness>=0 || springSpeed>=0 时，为spring动画，否则为常规动画
 */
@interface GICAnimation : GICBehavior{
    NSString *animationKey;
}

@property (nonatomic,readonly)NSInteger repeatCount; //重复次数
@property (nonatomic,readonly)BOOL autoreverses;
@property (nonatomic,readonly)GICAnimationTriggerType triggerType;
@property (nonatomic,readonly)NSString *eventName;

#pragma mark 常规动画
@property (nonatomic,readonly)CGFloat duration;//动画持续时间，默认0.5秒
@property (nonatomic,readonly)GICAnimationEaseMode easeMode;

#pragma mark spring 动画属性
//@property (nonatomic,readonly)CGFloat springVelocity;//spring动画初始速率
@property (nonatomic,readonly)CGFloat springBounciness;//spring动画 弹力 越大则震动幅度越大,0~20之间
@property (nonatomic,readonly)CGFloat springSpeed;//spring动画 速度 越大则动画结束越快，0~20之间

/**
 由子类实现

 @return <#return value description#>
 */
-(POPAnimatableProperty *)createAnimatableProperty;
@end
