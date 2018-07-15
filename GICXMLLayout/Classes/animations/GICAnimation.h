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

@interface GICAnimation : GICBehavior{
    POPAnimation *animation;
}


@property (nonatomic,readonly)CGFloat duration;//动画持续时间，默认0.5秒
@property (nonatomic,readonly)NSInteger repeatCount; //重复次数
@property (nonatomic,readonly,weak)id target;
@property (nonatomic,readonly)BOOL autoreverses;
@property (nonatomic,readonly)GICAnimationTriggerType triggerType;


/**
 由子类实现

 @return <#return value description#>
 */
-(POPPropertyAnimation *)createAnimation;
@end
