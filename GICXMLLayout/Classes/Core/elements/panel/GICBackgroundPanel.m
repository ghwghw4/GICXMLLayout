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
        _backgroundNode = [self gic_addSubElement:temp];
        NSAssert([_backgroundNode isKindOfClass:[ASDisplayNode class]], @"background 子元素必须是UI元素");
        return temp;
    }
    return [super gic_parseSubElementNotExist:element];
}

-(id)gic_willAddSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        if(subElement !=self.backgroundNode){
            _childNode = subElement;
        }
    }
    return [super gic_willAddSubElement:subElement];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSAssert(self.backgroundNode && self.childNode, @"background-panel子元素不能为空，background元素也不能为空");
    ASBackgroundLayoutSpec *backgroundLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:self.childNode background:self.backgroundNode];
    return backgroundLayout;
}
@end
