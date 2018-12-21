//
//  GICControl.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICControl.h"
#import "GICStringConverter.h"
#import "GICBoolConverter.h"

@implementation GICControl
+(NSString *)gic_elementName{
    return @"control";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"enable":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 ((GICControl *)target)->_highlightEvent = [[GICEvent alloc] initWithExpresion:value];
                 [(GICControl *)target setEnabled:[value boolValue]];
             }],
//             @"event-enable":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 ((GICControl *)target)->_enableEvent = [[GICEvent alloc] initWithExpresion:value];
//             }],
             @"selected":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 ((GICControl *)target)->_selectedEvent = [[GICEvent alloc] initWithExpresion:value];
                  [(GICControl *)target setSelected:[value boolValue]];
             }],
             };;
}

-(id)init{
    self = [super init];
    self.automaticallyManagesSubnodes = YES;
    self.userInteractionEnabled = YES;
    return self;
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        _normalNode = subElement;
    }
    return [super gic_willAddAndPrepareSubElement:subElement];
}

-(void)setHighlighted:(BOOL)highlighted{
    if(self.highlighted  == highlighted)
        return;
    [super setHighlighted:highlighted];
    [self updateContent];
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self updateContent];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self updateContent];
}


-(void)updateContent{
    
    if(self.normalNode == nil){
        // 这行代码是为了避免在没有normalNode的情况下crash的问题
        _normalNode = [ASDisplayNode new];
    }

    self.alpha = 1;
    if(self.highlighted){
        if(self.highlightNode){
            currentDisplayNode = self.highlightNode;
        }else{
            self.alpha = 0.8;
        }
    }else if (!self.enabled){
        if(self.disableNode){
            currentDisplayNode = self.disableNode;
        }else{
            self.alpha = 0.5;
        }
    }else if (self.selected){
        if(self.selectedNode){
            currentDisplayNode = self.selectedNode;
        }
    }else{
        currentDisplayNode = self.normalNode;
    }
    
    [self setNeedsLayout];
}

-(void)gic_parseElementCompelete{
    [super gic_parseElementCompelete];
    [self updateContent];
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSMutableArray *children = [NSMutableArray arrayWithObject:self.normalNode];
    if(self.highlightNode){
        [children addObject:self.highlightNode];
    }
    if(self.disableNode){
        [children addObject:self.disableNode];
    }
    if(self.selectedNode){
        [children addObject:self.selectedNode];
    }
    for(ASDisplayNode *node in children){
        [node setHidden:node!=currentDisplayNode];
    }
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:children];
    return absoluteSpec;
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if(element.childCount>0){
        NSString *elementName = element.name;
        if([elementName isEqualToString:@"highlight"]){
            id subelement = [NSObject gic_createElement:element.children.firstObject withSuperElement:self];
            if([subelement isKindOfClass:[ASDisplayNode class]]){
                _highlightNode = subelement;
            }
        }else if ([elementName isEqualToString:@"disable"]){
            id subelement = [NSObject gic_createElement:element.children.firstObject withSuperElement:self];
            if([subelement isKindOfClass:[ASDisplayNode class]]){
                _disableNode = subelement;
            }
        }else if ([elementName isEqualToString:@"selected"]){
            id subelement = [NSObject gic_createElement:element.children.firstObject withSuperElement:self];
            if([subelement isKindOfClass:[ASDisplayNode class]]){
                _selectedNode = subelement;
            }
        }
    }
    
    return [super gic_parseSubElementNotExist:element];
}
@end
