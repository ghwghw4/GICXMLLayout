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

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h = [self calcuActualHeight];
    NSString *name = self.gic_Name;
    NSLog(@"%@",name);
    NSLog(@"%@",self);
    if(![name isEqualToString:@"root-panel"]){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h);
        }];
    }
}

-(void)setHeightBottomConstrant:(MASConstraintMaker *)make view:(UIView *)view margin:(UIEdgeInsets)margin{
    make.height.mas_equalTo(view.gic_Height);
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

-(void)setTopConstrant:(MASConstraintMaker *)make marginTop:(CGFloat)top{
    if(self.subviews.count>1){
        UIView *preView = [self.subviews objectAtIndex:self.subviews.count-2];
        make.top.mas_equalTo(preView.mas_bottom).mas_offset(top);
    }else{
        [super setTopConstrant:make marginTop:top];
    }
}

-(CGFloat)calcuActualHeight{
    if(self.gic_Height>0){
        return self.gic_Height;
    }
    UIView *lastSubview = [self.subviews lastObject];
    return CGRectGetMaxY(lastSubview.frame);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
