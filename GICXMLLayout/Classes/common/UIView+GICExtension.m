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

-(void)setGic_ZIndex:(NSInteger)gic_ZIndex{
     objc_setAssociatedObject(self, "gic_ZIndex", @(gic_ZIndex), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)gic_ZIndex{
    return [objc_getAssociatedObject(self, "gic_ZIndex") integerValue];
}

-(void)setGic_marginTop:(CGFloat)gic_marginTop{
    UIEdgeInsets margin = [self gic_margin];
    margin.top = gic_marginTop;
    self.gic_margin = margin;
}

-(CGFloat)gic_marginTop{
    return self.gic_margin.top;
}


-(void)setGic_marginLeft:(CGFloat)gic_marginLeft{
    UIEdgeInsets margin = [self gic_margin];
    margin.left = gic_marginLeft;
    self.gic_margin = margin;
}

-(CGFloat)gic_marginLeft{
    return self.gic_margin.left;
}

-(void)setGic_marginRight:(CGFloat)gic_marginRight{
    UIEdgeInsets margin = [self gic_margin];
    margin.right = gic_marginRight;
    self.gic_margin = margin;
}

-(CGFloat)gic_marginRight{
    return self.gic_margin.right;
}

-(void)setGic_marginBottom:(CGFloat)gic_marginBottom{
    UIEdgeInsets margin = [self gic_margin];
    margin.bottom = gic_marginBottom;
    self.gic_margin = margin;
}

-(CGFloat)gic_marginBottom{
    return self.gic_margin.bottom;
}
@end

