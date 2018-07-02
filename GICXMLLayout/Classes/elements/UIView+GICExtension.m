//
//  UIView+GICExtension.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "UIView+GICExtension.h"
#import <objc/runtime.h>

@implementation UIView (GICExtension)
-(void)setGic_Width:(CGFloat)gic_Width{
    objc_setAssociatedObject(self, "gic_Width", @(gic_Width), OBJC_ASSOCIATION_ASSIGN);
}

-(CGFloat)gic_Width{
    return [objc_getAssociatedObject(self, "gic_Width") floatValue];
}

-(void)setGic_Height:(CGFloat)gic_Height{
    objc_setAssociatedObject(self, "gic_Height", @(gic_Height), OBJC_ASSOCIATION_ASSIGN);
}

-(CGFloat)gic_Height{
    return [objc_getAssociatedObject(self, "gic_Height") floatValue];
}

-(void)setGic_margin:(UIEdgeInsets)gic_margin{
    objc_setAssociatedObject(self, "gic_margin", [NSValue valueWithUIEdgeInsets:gic_margin], OBJC_ASSOCIATION_RETAIN);
}

-(UIEdgeInsets)gic_margin{
    NSValue *v = objc_getAssociatedObject(self, "gic_margin");
    if(v){
       return  [v UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

-(void)setGic_Name:(NSString *)gic_Name{
     objc_setAssociatedObject(self, "gic_Name", gic_Name ,OBJC_ASSOCIATION_RETAIN);
}

-(NSString *)gic_Name{
    return objc_getAssociatedObject(self, "gic_Name");
}
@end
