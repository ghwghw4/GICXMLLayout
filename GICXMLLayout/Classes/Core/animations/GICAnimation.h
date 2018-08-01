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
    GICAnimationTriggerType_tap = 2//单击的时候
}GICAnimationTriggerType;

typedef enum {
    GICAnimationEaseMode_Linear = 0 ,//线性动画
    GICAnimationEaseMode_EaseIn = 1,//
    GICAnimationEaseMode_EaseOut = 2,//
    GICAnimationEaseMode_EaseInEaseOut = 3//
}GICAnimationEaseMode;

@interface GICAnimation : GICBehavior{
    NSString *animationKey;
}


@property (nonatomic,readonly)CGFloat duration;//动画持续时间，默认0.5秒
@property (nonatomic,readonly)NSInteger repeatCount; //重复次数
@property (nonatomic,readonly)BOOL autoreverses;
@property (nonatomic,readonly)GICAnimationEaseMode easeMode;
@property (nonatomic,readonly)GICAnimationTriggerType triggerType;


/**
 由子类实现

 @return <#return value description#>
 */
-(POPAnimatableProperty *)createAnimatableProperty;
@end
