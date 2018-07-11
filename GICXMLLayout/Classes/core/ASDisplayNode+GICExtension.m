//
//  ASDisplayNode+GICExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNode+GICExtension.h"

@implementation ASDisplayNode (GICExtension)
-(GICDisplayNodeExtensionProperties *)gic_ExtensionProperties{
    GICDisplayNodeExtensionProperties *v =objc_getAssociatedObject(self, "gic_ExtensionProperties");
    if(!v){
        v = [GICDisplayNodeExtensionProperties new];
        objc_setAssociatedObject(self, "gic_ExtensionProperties", v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}@end
