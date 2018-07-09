//
//  GICViewExtensionProperties.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICViewExtensionProperties.h"

@implementation GICViewExtensionProperties
-(void)setMarginTop:(CGFloat)marginTop{
    UIEdgeInsets margin = self.margin;
    margin.top = marginTop;
    self.margin = margin;
}

-(CGFloat)marginTop{
    return self.margin.top;
}

-(void)setMarginLeft:(CGFloat)marginLeft{
    UIEdgeInsets margin = self.margin;
    margin.left = marginLeft;
    self.margin = margin;
}

-(CGFloat)marginLeft{
    return self.margin.left;
}

-(void)setMarginRight:(CGFloat)marginRight{
    UIEdgeInsets margin = self.margin;
    margin.right = marginRight;
    self.margin = margin;
}

-(CGFloat)marginRight{
    return self.margin.right;
}

-(void)setMarginBottom:(CGFloat)marginBottom{
    UIEdgeInsets margin = self.margin;
    margin.bottom = marginBottom;
    self.margin = margin;
}

-(CGFloat)marginBottom{
    return self.margin.bottom;
}
@end
