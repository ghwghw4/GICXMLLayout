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



-(void)addSubview:(UIView *)view{
    [super addSubview:view];
//    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.textLabelLeftLayout = make.left.equalTo(self.checkedButton.mas_right);
//        make.centerY.equalTo(self.mas_centerY);
//        make.height.mas_equalTo(checkBoxWidth);
//        make.right.lessThanOrEqualTo(self.mas_right);
//    }];
}

-(void)layoutView:(UIView *)view{
    UIEdgeInsets margin = view.gic_margin;
    UIView *preView = nil;
    NSInteger index = [self.subviews indexOfObject:view];
    if(index>0){
        preView = [self.subviews objectAtIndex:index-1];
    }
    
    NSAssert(view.gic_Height>0 || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[GICPanel class]] , @"stackpanel 所有的元素(除了lable、panel)都必须显示设置高度,否则按照高度为0处理");
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        // left
        make.left.mas_offset(margin.left);
        // top
        if(preView){
            make.top.mas_equalTo(preView.mas_bottom).mas_offset(margin.top + preView.gic_margin.bottom);
        }else{
            make.top.mas_offset(margin.top);
        }
        
        if(view.gic_Height>0)
            make.height.mas_equalTo(view.gic_Height);
        
        // width
        if(view.gic_Width > 0)
            make.width.mas_equalTo(view.gic_Width);
        else
            make.right.mas_offset(-margin.right);
    }];
}

-(CGFloat)calcuActualHeight{
//    if(self.gic_Height>0){
//        return self.gic_Height;
//    }
    UIView *lastSubview = [self.subviews lastObject];
    return CGRectGetMaxY(lastSubview.frame) + lastSubview.gic_margin.bottom;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
