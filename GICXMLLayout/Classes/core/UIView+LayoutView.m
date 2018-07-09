//
//  UIView+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "UIView+LayoutView.h"
#import "UIColor+Extension.h"
#import "GDataXMLNode.h"
#import "GICXMLLayout.h"
#import "UIView+GICExtension.h"
#import <objc/runtime.h>

#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICStringConverter.h"
#import "GICDataBinding.h"
#import "NSObject+GICDataBinding.h"
#import "GICTapEvent.h"
#import "GICStringConverter.h"
#import "UIView+GICEvent.h"

@implementation UIView (LayoutView)

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UIView *)target setBackgroundColor:value];
                         }],
                         @"height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_ExtensionProperties.height = [value floatValue];
                         }],
                         @"width":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_ExtensionProperties.width = [value floatValue];
                         }],
                         @"margin":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [((UIView *)target).gic_ExtensionProperties setValue:value forKey:@"margin"];
                         }],
                         @"margin-top":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_ExtensionProperties.marginTop = [value floatValue];
                         }],
                         @"margin-left":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_ExtensionProperties.marginLeft = [value floatValue];
                         }],
                         @"margin-right":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_ExtensionProperties.marginRight = [value floatValue];
                         }],
                         @"margin-bottom":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             ((UIView *)target).gic_ExtensionProperties.marginBottom = [value floatValue];
                         }],
                         @"event-tap":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             GICTapEvent *e=[[GICTapEvent alloc] initWithExpresion:value];
                             [(UIView *)target gic_event_addEvent:e];
                         }],
                         };
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

+(NSString *)gic_elementName{
    return nil;
}

//-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
//    for(GDataXMLElement *child in children){
//        id childElement = [GICXMLLayout createElement:child];
//        if(childElement == nil)
//            continue;
//        [self gic_addSubElement:childElement];
//    }
//}

-(NSArray *)gic_subElements{
    return self.subviews;
}

-(void)gic_addSubElement:(NSObject *)subElement{
    if([subElement isKindOfClass:[UIView class]]){
        [self addSubview:(UIView *)subElement];
    }else{
        [super gic_addSubElement:subElement];
    }
}

-(void)gic_LayoutSubView:(UIView *)subView{
    UIEdgeInsets margin = subView.gic_ExtensionProperties.margin;
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(margin.top);
        make.left.mas_offset(margin.left);
        
        if(subView.gic_ExtensionProperties.width > 0)
            make.width.mas_equalTo(subView.gic_ExtensionProperties.width);
        else
            make.right.mas_offset(-margin.right);
        
        if(subView.gic_ExtensionProperties.height > 0)
            make.height.mas_equalTo(subView.gic_ExtensionProperties.height);
        else
            make.bottom.mas_offset(-margin.bottom);
    }];
}

-(NSObject *)gic_getSuperElement{
    UIView *force = self.gic_ExtensionProperties.foreSuperElement;
    if(force){
        return force;
    }
    return [self superview];
}

-(void)gic_removeAllSubElements{
    for(UIView *v in self.subviews){
        [v removeFromSuperview];
    }
}
@end
