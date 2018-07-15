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

@implementation ASDisplayNode (GICExtension)
+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return @{
             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setBackgroundColor:value];
             }],
             @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(id target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.height = ASDimensionMake([value floatValue]);
             }],
             @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.width = ASDimensionMake([value floatValue]);
             }],
             @"size":[[GICSizeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGSize size = [(NSValue *)value CGSizeValue];
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.width = ASDimensionMake(size.width);
                 node.style.height = ASDimensionMake(size.height);
             }],
             @"position":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGPoint point = [(NSValue *)value CGPointValue];
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.layoutPosition = point;
             }],
             @"max-width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.maxWidth = ASDimensionMake([value floatValue]);
             }],
             @"max-height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.maxHeight = ASDimensionMake([value floatValue]);
             }],
             @"space-before":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.spacingBefore = [value floatValue];
             }],
             @"space-after":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.spacingAfter = [value floatValue];
             }],
             @"flex-grow":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexGrow = [value integerValue];
             }],
             @"flex-shrink":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node =  (ASDisplayNode*)target;
                 node.style.flexShrink = [value integerValue];
             }],
             @"dock-horizal":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 (target.gic_ExtensionProperties).dockHorizalModel = (GICDockPanelHorizalModel)[value integerValue];
             }],
             @"dock-vertical":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 (target.gic_ExtensionProperties).dockVerticalModel = (GICDockPanelVerticalModel)[value integerValue];
             }],
             @"hidden":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setHidden:[value boolValue]];
             }],
             @"alpha":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(ASDisplayNode *)target setAlpha:[value floatValue]];
             }],
             @"corner-radius":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ASDisplayNode *node = (ASDisplayNode *)target;
                 node.cornerRadius = [value floatValue];
             }],
             @"event-tap":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICTapEvent *e=[[GICTapEvent alloc] initWithExpresion:value];
                 [target gic_event_addEvent:e];
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
             };
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        [self addSubnode:subElement];
    }else if ([subElement isKindOfClass:[GICAnimations class]]){ //添加动画
        for(GICAnimation *a in ((GICAnimations *)subElement).animations){
            [self gic_addAnimation:a];
        }
    }else{
        [super gic_addSubElement:subElement];
    }
}

-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    [super gic_removeSubElements:subElements];
    for(id sub in subElements){
        if([sub isKindOfClass:[ASDisplayNode class]]  && [self.subnodes containsObject:sub]){
            [(ASDisplayNode *)sub removeFromSupernode];
        }
    }
}

-(void)gic_safeView:(void (^)(UIView *view))cb{
    dispatch_async(dispatch_get_main_queue(), ^{
        cb(self.view);
    });
}

@end
