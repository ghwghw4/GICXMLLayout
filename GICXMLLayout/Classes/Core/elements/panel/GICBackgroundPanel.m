//
//  GICBackgroundPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICBackgroundPanel.h"

@implementation GICBackgroundPanel
+(NSString *)gic_elementName{
    return @"background-panel";
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:@"background"]){
        NSAssert(element.childCount ==1, @"background必须包含一个子元素，且只能包含一个子元素");
        id temp = [NSObject gic_createElement:[element children].firstObject withSuperElement:self];
        NSAssert([temp isKindOfClass:[ASDisplayNode class]], @"background 子元素必须是UI元素");
        _backgroundNode = temp;
        [self gic_addSubElement:temp];
    }
    return [super gic_parseSubElementNotExist:element];
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        if(subElement !=self.backgroundNode){
            NSAssert(self.childNode ==nil, @"background-panel只能有一个非背景的子元素");
            _childNode = subElement;
        }
    }
    return [super gic_addSubElement:subElement];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSAssert(self.backgroundNode && self.childNode, @"background-panel子元素不能为空，background元素也不能为空");
    ASBackgroundLayoutSpec *backgroundLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:self.childNode background:self.backgroundNode];
    return backgroundLayout;
}
@end
