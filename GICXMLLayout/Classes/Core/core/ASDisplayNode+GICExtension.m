//
//  ASDisplayNode+GICExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNode+GICExtension.h"
#import <objc/runtime.h>
#import "GICTapEvent.h"

#import "GICLayoutSizeConverter.h"
#import "GICBoolConverter.h"
#import "GICStringConverter.h"
#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICStringConverter.h"
#import "GICStringConverter.h"
#import "GICSizeConverter.h"
#import "CGPointConverter.h"
#import "GICDimensionConverter.h"

@implementation ASDisplayNode (GICExtension)
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setBackgroundColor:value];
             } withGetter:^id(id target) {
                 return [(ASDisplayNode *)target backgroundColor];
             }],
             @"height":[[GICDimensionConverter alloc] initWithPropertySetter:^(id target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.height = [(NSValue *)value ASDimension];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return [NSValue valueWithASDimension:[(ASDisplayNode*)target style].height];
             }],
             @"width":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.width = [(NSValue *)value ASDimension];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return [NSValue valueWithASDimension:[(ASDisplayNode*)target style].width];
             }],
             @"size":[[GICLayoutSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 ASLayoutSize size = [(NSValue *)value ASLayoutSize];
                 node.style.width = size.width;
                 node.style.height = size.height;
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 ASLayoutSize size = ASLayoutSizeMake(node.style.width, node.style.height);
                 return [NSValue valueWithASLayoutSize:size];
             }],
             @"position":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGPoint point = [(NSValue *)value CGPointValue];
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.layoutPosition = point;
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 return [NSValue valueWithCGPoint:node.style.layoutPosition];
             }],
             @"max-width":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.maxWidth = [(NSValue *)value ASDimension];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return [NSValue valueWithASDimension:[(ASDisplayNode*)target style].maxWidth];
             }],
             @"max-height":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.maxHeight = [(NSValue *)value ASDimension];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return [NSValue valueWithASDimension:[(ASDisplayNode*)target style].maxHeight];
             }],
             @"space-before":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.spacingBefore = [value floatValue];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode*)target style].spacingBefore);
             }],
             @"space-after":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.spacingAfter = [value floatValue];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode*)target style].spacingAfter);
             }],
             @"flex-grow":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexGrow = [value integerValue];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode*)target style].flexGrow);
             }],
             @"flex-shrink":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexShrink = [value integerValue];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode*)target style].flexShrink);
             }],
             @"flex-basics":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexBasis = [(NSValue *)value ASDimension];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return [NSValue valueWithASDimension:[(ASDisplayNode*)target style].flexBasis];
             }],
             @"align-self":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.alignSelf = [value integerValue];
                 [node layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode*)target style].alignSelf);
             }],
             @"dock-horizal":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 (target.gic_ExtensionProperties).dockHorizalModel = (GICDockPanelHorizalModel)[value integerValue];
                 [(ASDisplayNode *)target layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([target gic_ExtensionProperties].dockHorizalModel);
             }],
             @"dock-vertical":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 (target.gic_ExtensionProperties).dockVerticalModel = (GICDockPanelVerticalModel)[value integerValue];
                 [(ASDisplayNode *)target layoutAttributeChanged];
             } withGetter:^id(id target) {
                 return @([target gic_ExtensionProperties].dockVerticalModel);
             }],
             @"hidden":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setHidden:[value boolValue]];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target isHidden]);
             }],
             @"alpha":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setAlpha:[value floatValue]];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target alpha]);
             }],
             @"event-tap":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [GICTapEvent createEventWithExpresion:value withEventName:@"event-tap" toTarget:target];
             } withGetter:^id(id target) {
                 return [target gic_event_findFirstWithEventClass:[GICTapEvent class]];
             }],
             @"corner-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.cornerRadius = [value floatValue];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target cornerRadius]);
             }],
             @"shadow-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.shadowColor = [value CGColor];
             } withGetter:^id(id target) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 if(node.shadowColor)
                     return [UIColor colorWithCGColor:node.shadowColor];
                 return nil;
             }],
             @"shadow-opacity":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 CGFloat v = [value floatValue];
                 v = MAX(0, v);
                 v = MIN(1, v);
                 node.shadowOpacity = v;
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target shadowOpacity]);
             }],
             @"shadow-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.shadowRadius = [value floatValue];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target shadowRadius]);
             }],
             @"shadow-offset":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.shadowOffset = [(NSValue *)value CGSizeValue];
             } withGetter:^id(id target) {
                 return [NSValue valueWithCGSize:[(ASDisplayNode *)target shadowOffset]];
             }],
             @"clips-bounds":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.clipsToBounds = [value boolValue];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target clipsToBounds]);
             }],
             @"border-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.borderColor = [value CGColor];
             } withGetter:^id(id target) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 if(node.borderColor)
                     return [UIColor colorWithCGColor:node.borderColor];
                 return nil;
             }],
             @"border-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.borderWidth = [value floatValue];
             } withGetter:^id(id target) {
                 return @([(ASDisplayNode *)target borderWidth]);
             }],
             };
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
//        [self addSubnode:subElement];
        if(self.nodeLoaded){
            [self setNeedsLayout];
        }
        return subElement;
    }else{
       return [super gic_addSubElement:subElement];
    }
}

-(id)gic_insertSubElement:(id)subElement elementOrder:(CGFloat)order{
    ((NSObject *)subElement).gic_ExtensionProperties.elementOrder = order;
    if([subElement isKindOfClass:[ASDisplayNode class]]){
//        ASDisplayNode *findNode = nil;
//        for(ASDisplayNode *node in self.subnodes){
//            if(order >=node.gic_ExtensionProperties.elementOrder){
//                findNode = node;
//            }
//        }
//        if(findNode)
//            [self insertSubnode:subElement aboveSubnode:findNode];
//        else
//            [self addSubnode:subElement];
        if(self.nodeLoaded){
            [self setNeedsLayout];
        }
        return subElement;
    }
    // TODO:对于elmentref 的insert
    return [self gic_addSubElement:subElement];
}

-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    [super gic_removeSubElements:subElements];
    BOOL needLayout = NO;
    for(id sub in subElements){
        if([sub isKindOfClass:[ASDisplayNode class]]){
            needLayout = YES;
        }
    }
    if(self.nodeLoaded && needLayout){
        [self setNeedsLayout];
    }
}

-(void)gic_safeView:(void (^)(UIView *view))cb{
    dispatch_async(dispatch_get_main_queue(), ^{
        cb(self.view);
    });
}

-(void)layoutAttributeChanged{
    if(self.nodeLoaded){
        [self setNeedsLayout];
    }
}


-(NSArray<ASDisplayNode*> *)gic_displayNodes{
    NSMutableArray *mutArray=[NSMutableArray array];
    for(id node in [self gic_subElements]){
        if([node isKindOfClass:[ASDisplayNode class]]){
            [mutArray addObject:node];
        }
    }
    [mutArray sortUsingComparator:^NSComparisonResult(ASDisplayNode * obj1, ASDisplayNode * obj2) {
        return obj1.gic_ExtensionProperties.elementOrder > obj2.gic_ExtensionProperties.elementOrder? NSOrderedDescending:NSOrderedAscending;
    }];
    return mutArray;
}

@end
