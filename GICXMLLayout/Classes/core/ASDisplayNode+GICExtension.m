//
//  ASDisplayNode+GICExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNode+GICExtension.h"
#import <objc/runtime.h>
#import "GICTapEvent.h"
#import "GICAnimations.h"
#import "NSObject+GICAnimation.h"

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
             }],
             @"height":[[GICDimensionConverter alloc] initWithPropertySetter:^(id target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.height = ASDimensionMake((NSString *)value);
                 [node layoutAttributeChanged];
             }],
             @"width":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.width = ASDimensionMake((NSString *)value);
                 [node layoutAttributeChanged];
             }],
             @"size":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 NSArray *strs = [value componentsSeparatedByString:@" "];
                 if(strs.count==1){
                     ASDimension h = ASDimensionMake((NSString *)strs[0]);
                     if(ASDimensionEqualToDimension(h, ASDimensionAuto)){
                         h = ASDimensionMake([value floatValue]);
                     }
                     node.style.width = h;
                     node.style.height = h;
                 }else if(strs.count==2){
                     ASDimension w = ASDimensionMake((NSString *)strs[0]);
                     if(ASDimensionEqualToDimension(w, ASDimensionAuto)){
                         w = ASDimensionMake([(NSString *)strs[0] floatValue]);
                     }
                     node.style.width = w;
                     
                     ASDimension h = ASDimensionMake((NSString *)strs[1]);
                     if(ASDimensionEqualToDimension(h, ASDimensionAuto)){
                         h = ASDimensionMake([(NSString *)strs[1] floatValue]);
                     }
                     node.style.height = h;
                 }
                 [node layoutAttributeChanged];
             }],
             @"position":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGPoint point = [(NSValue *)value CGPointValue];
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.layoutPosition = point;
                 [node layoutAttributeChanged];
             }],
             @"max-width":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.maxWidth = ASDimensionMake((NSString *)value);
                 [node layoutAttributeChanged];
             }],
             @"max-height":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.maxHeight = ASDimensionMake((NSString *)value);
                 [node layoutAttributeChanged];
             }],
             @"space-before":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.spacingBefore = [value floatValue];
                 [node layoutAttributeChanged];
             }],
             @"space-after":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.spacingAfter = [value floatValue];
                 [node layoutAttributeChanged];
             }],
             @"flex-grow":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexGrow = [value integerValue];
                 [node layoutAttributeChanged];
             }],
             @"flex-shrink":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexShrink = [value integerValue];
                 [node layoutAttributeChanged];
             }],
             @"flex-basics":[[GICDimensionConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexBasis = ASDimensionMake((NSString *)value);
                 [node layoutAttributeChanged];
             }],
             @"align-self":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.alignSelf = [value integerValue];
                 [node layoutAttributeChanged];
             }],
             @"dock-horizal":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 (target.gic_ExtensionProperties).dockHorizalModel = (GICDockPanelHorizalModel)[value integerValue];
                 [(ASDisplayNode *)target layoutAttributeChanged];
             }],
             @"dock-vertical":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 (target.gic_ExtensionProperties).dockVerticalModel = (GICDockPanelVerticalModel)[value integerValue];
                 [(ASDisplayNode *)target layoutAttributeChanged];
             }],
             @"hidden":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setHidden:[value boolValue]];
             }],
             @"alpha":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setAlpha:[value floatValue]];
             }],
             @"event-tap":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICTapEvent *e=[[GICTapEvent alloc] initWithExpresion:value];
                 [target gic_event_addEvent:e];
             }],
             @"corner-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.cornerRadius = [value floatValue];
             }],
             @"shadow-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.shadowColor = [value CGColor];
             }],
             @"shadow-opacity":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 CGFloat v = [value floatValue];
                 v = MAX(0, v);
                 v = MIN(1, v);
                 node.shadowOpacity = v;
             }],
             @"shadow-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.shadowRadius = [value floatValue];
             }],
             @"shadow-offset":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.shadowOffset = [(NSValue *)value CGSizeValue];
             }],
             @"clips-bounds":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.clipsToBounds = [value boolValue];
             }],
             @"border-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.borderColor = [value CGColor];
             }],
             @"border-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.borderWidth = [value floatValue];
             }],
             };
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        [self addSubnode:subElement];
        if(self.nodeLoaded){
            [self setNeedsLayout];
        }
        return subElement;
    }else if ([subElement isKindOfClass:[GICAnimations class]]){ //添加动画
        for(GICAnimation *a in ((GICAnimations *)subElement).animations){
            a.gic_ExtensionProperties.superElement = self;
            [self gic_addAnimation:a];
        }
        return subElement;
    }else{
       return [super gic_addSubElement:subElement];
    }
}

-(id)gic_insertSubElement:(id)subElement elementOrder:(NSInteger)order{
    ((NSObject *)subElement).gic_ExtensionProperties.elementOrder = order;
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        ASDisplayNode *findNode = nil;
        for(ASDisplayNode *node in self.subnodes){
            if(order >=node.gic_ExtensionProperties.elementOrder){
                findNode = node;
            }
        }
        if(findNode)
            [self insertSubnode:subElement aboveSubnode:findNode];
        else
            [self addSubnode:subElement];
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
        if([sub isKindOfClass:[ASDisplayNode class]]  && [self.subnodes containsObject:sub]){
            [(ASDisplayNode *)sub removeFromSupernode];
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

@end
