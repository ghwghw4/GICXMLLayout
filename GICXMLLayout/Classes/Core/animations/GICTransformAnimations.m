//
//  GICTransformAnimations.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/23.
//

#import "GICTransformAnimations.h"
#import "GICMoveAnimation.h"
#import "GICRotateAnimation.h"
#import "GICScaleAnimation.h"

@implementation GICTransformAnimations
static NSDictionary<NSString *,Class> *transformAnimationsMap = nil;

+(void)initialize{
    transformAnimationsMap = @{
                               [GICMoveAnimation gic_elementName]:[GICMoveAnimation class],
                               [GICRotateAnimation gic_elementName]:[GICRotateAnimation class],
                               [GICScaleAnimation gic_elementName]:[GICScaleAnimation class],
                               };
}

+(NSString *)gic_elementName{
    return @"anim-transforms";
}

-(BOOL)gic_parseOnlyOneSubElement{
    return NO;
}

-(id)init{
    self = [super init];
    transforms = [NSMutableArray array];
    return self;
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    Class animationClass = [transformAnimationsMap objectForKey:element.name];
    if(animationClass){
        [transforms addObject:[animationClass new]];
        return transforms.lastObject;
    }
    return [super gic_parseSubElementNotExist:element];
}


-(POPAnimatableProperty *)createAnimatableProperty{
    if(![self.target isKindOfClass:[ASDisplayNode class]]){
        return nil;
    }
    ASDisplayNode *node = (ASDisplayNode *)self.target;
    @weakify(self)
    POPAnimatableProperty *prop =  [POPAnimatableProperty propertyWithName:@"GICXMLLayout_moveAni" initializer:^(POPMutableAnimatableProperty *prop) {
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            @strongify(self)
            CATransform3D t = CATransform3DIdentity;
            CGFloat p = values[0] / 100.0;
            for(GICTransformAnimation *ani in self->transforms){
                t = CATransform3DConcat(t, [ani makeTransformWithPercent:p]);
            }
            node.transform = t;
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    return prop;
}
@end
