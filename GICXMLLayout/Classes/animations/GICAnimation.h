//
//  GICAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import <GICXMLLayout/GICXMLLayout.h>
#import <pop/POP.h>

@interface GICAnimation : GICBehavior{
    POPAnimation *animation;
}

@property (nonatomic,readonly)NSString *fromValue;
@property (nonatomic,readonly)NSString *toValue;

/**
 由子类实现

 @return <#return value description#>
 */
-(POPAnimation *)createAnimation;
@end
