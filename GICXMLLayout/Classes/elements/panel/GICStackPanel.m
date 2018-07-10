//
//  GICStackPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICStackPanel.h"
#import <Masonry/Masonry.h>

@implementation GICStackPanel
+(NSString *)gic_elementName{
    return @"stack-panel";
}

-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    [super gic_removeSubElements:subElements];
    // 删除后重新计算布局
    for(UIView *v in self.subviews){
        [self gic_LayoutSubView:v];
    }
}


-(void)gic_LayoutSubView:(UIView *)view{
    UIEdgeInsets margin = view.gic_ExtensionProperties.margin;
    UIView *preView = nil;
    NSInteger index = [self.subviews indexOfObject:view];
    if(index>0){
        preView = [self.subviews objectAtIndex:index-1];
    }
    GICViewExtensionProperties *viewExtensionProperties = view.gic_ExtensionProperties;
    NSAssert(viewExtensionProperties.height>0 || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[GICPanel class]] , @"stackpanel 所有的元素(除了lable、panel)都必须显示设置高度");
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        // left
        make.left.mas_offset(margin.left);
        // top
        if(preView){
            make.top.mas_equalTo(preView.mas_bottom).mas_offset(margin.top + preView.gic_ExtensionProperties.margin.bottom);
        }else{
            make.top.mas_offset(margin.top);
        }
        // height
        if(viewExtensionProperties.height>0)
            make.height.mas_equalTo(viewExtensionProperties.height);
        
        // width
        if(viewExtensionProperties.width > 0)
            make.width.mas_equalTo(viewExtensionProperties.width);
        else
            make.right.mas_offset(-margin.right);
    }];
}

-(CGFloat)gic_calcuActualHeight{
    [self setNeedsLayout];
    if(self.subviews.count==0)
        return self.frame.size.height;
    UIView *lastSubview = [self.subviews lastObject];
//    UIEdgeInsets margin = self.gic_ExtensionProperties.margin;
    return CGRectGetMaxY(lastSubview.frame) + lastSubview.gic_ExtensionProperties.margin.bottom;
}
@end
