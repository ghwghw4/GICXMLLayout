//
//  GICPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICPanel.h"
#import "GICXMLLayout.h"
#import "GICDirective.h"
#import "GICLayoutUtils.h"

@implementation GICPanel
+(NSString *)gic_elementName{
    return @"panel";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return [GICLayoutUtils commonPropertyConverters];
}

-(id)init{
    self = [super init];
    _childNodes = [NSMutableArray array];
    _style = [[ASLayoutElementStyle alloc] init];
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

-(NSArray *)gic_subElements{
    return self.childNodes;
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
    [self mergeStyle:absoluteSpec];
    return absoluteSpec;
}

-(void)mergeStyle:(ASLayoutSpec *)spec{
    spec.style.height = self.style.height;
    spec.style.width = self.style.width;
    spec.style.layoutPosition = self.style.layoutPosition;
    spec.style.maxWidth = self.style.maxWidth;
    spec.style.maxHeight = self.style.maxHeight;
    spec.style.spacingBefore = self.style.spacingBefore;
    spec.style.spacingAfter = self.style.spacingAfter;
    spec.style.flexGrow = self.style.flexGrow;
    spec.style.flexShrink = self.style.flexShrink;
}
@end
