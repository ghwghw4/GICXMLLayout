//
//  ASDisplayNode+GICExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNode+GICExtension.h"
#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICLayoutUtils.h"
#import <objc/runtime.h>
#import "GICStringConverter.h"
#import "GICTapEvent.h"
#import "GICBoolConverter.h"
#import "GICAnimations.h"
#import "NSObject+GICAnimation.h"

@implementation ASDisplayNode (GICExtension)
-(void)setGic_panel:(GICPanel *)gic_panel{
    objc_setAssociatedObject(self, "gic_panel", gic_panel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(GICPanel *)gic_panel{
    return objc_getAssociatedObject(self, "gic_panel");
}


+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertyConverters{
    NSMutableDictionary *mutDict=  [@{
                                      @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                            [(ASDisplayNode *)target setBackgroundColor:value];
                                        }],
                                      @"touch-enable":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                                            [(ASDisplayNode *)target setUserInteractionEnabled:[value boolValue]];
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
                                      
                                      } mutableCopy];
    [mutDict addEntriesFromDictionary:[GICLayoutUtils commonPropertyConverters]];
    return mutDict;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICPanel class]]){
        self.gic_panel = subElement;
    }else if([subElement isKindOfClass:[ASDisplayNode class]]){
        NSAssert(NO, @"UI元素只能添加panel，不允许添加其他的UI元素");
    }else if ([subElement isKindOfClass:[GICAnimations class]]){ //添加动画
        for(GICAnimation *a in ((GICAnimations *)subElement).animations){
            [self gic_addAnimation:a];
        }
    }else{
        [super gic_addSubElement:subElement];
    }
}

//-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
//    for(id sub in subElements){
//        if([sub isKindOfClass:[ASDisplayNode class]]  && [self.subnodes containsObject:sub]){
//            [(ASDisplayNode *)sub removeFromSupernode];
//        }
//    }
//}

-(void)gic_safeView:(void (^)(UIView *view))cb{
    dispatch_async(dispatch_get_main_queue(), ^{
        cb(self.view);
    });
}

- (ASLayoutSpec *)gic_layoutSpecThatFits:(ASSizeRange)constrainedSize{
    if(self.gic_panel)
        return [self.gic_panel layoutSpecThatFits:constrainedSize];
    return [[ASAbsoluteLayoutSpec alloc] init];
}
@end
