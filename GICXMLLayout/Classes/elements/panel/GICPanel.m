//
//  GICPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICPanel.h"
#import "GICXMLLayout.h"
#import "GICDirective.h"
//#import "GICView.h"


@implementation GICPanel
+(NSString *)gic_elementName{
    return @"panel";
}

-(id)init{
    self = [super init];
    _childNodes = [NSMutableArray array];
    return self;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        [self.childNodes addObject:subElement];
    }else if ([subElement isKindOfClass:[GICPanel class]]){
        [self.childNodes addObject:subElement];
    }else{
        [super gic_addSubElement:subElement];
    }
}

-(NSArray<ASDisplayNode *> *)getAllDisplayNodes{
    NSMutableArray *mutArray =[NSMutableArray array];
    for(id node in self.childNodes){
        if([node isKindOfClass:[ASDisplayNode class]]){
            [mutArray addObject:node];
        }else if ([node isKindOfClass:[GICPanel class]]){
            [mutArray addObjectsFromArray:[node getAllDisplayNodes]];
        }
    }
    return mutArray;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSMutableArray *children = [NSMutableArray array];
    for(id node in self.childNodes){
        if([node isKindOfClass:[ASDisplayNode class]]){
            [children addObject:node];
        }else if ([node isKindOfClass:[GICPanel class]]){
            [children addObject:[node layoutSpecThatFits:constrainedSize]];
        }
    }
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:children];
    absoluteSpec.sizing = ASAbsoluteLayoutSpecSizingSizeToFit;
    return absoluteSpec;
}
@end
