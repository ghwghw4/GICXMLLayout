//
//  UIView+GICExtension.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "UIView+GICExtension.h"
#import <objc/runtime.h>

@implementation UIView (GICExtension)

-(GICViewExtensionProperties *)gic_ExtensionProperties{
    GICViewExtensionProperties *v =objc_getAssociatedObject(self, "gic_ExtensionProperties");
    if(!v){
        v = [GICViewExtensionProperties new];
        objc_setAssociatedObject(self, "gic_ExtensionProperties", v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}
@end

