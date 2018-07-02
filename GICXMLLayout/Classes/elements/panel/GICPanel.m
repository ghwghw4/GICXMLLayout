//
//  GICPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICPanel.h"
#import "UIView+GICExtension.h"

@implementation GICPanel
+(NSString *)gic_elementName{
    return @"panel";
}

-(CGFloat)calcuActualHeight{
    return self.frame.size.height;
}

-(void)addSubview:(UIView *)view{
    [super addSubview:view];
    [self layoutView:view];
}

-(void)layoutView:(UIView *)view{
    UIEdgeInsets margin = view.gic_margin;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(margin.left);
        [self setTopConstrant:make marginTop:margin.top];
        [self setHeightBottomConstrant:make view:view margin:margin];
        
        if(view.gic_Width > 0)
            make.width.mas_equalTo(view.gic_Width);
        else
            make.right.mas_offset(-margin.right);
    }];
}

-(void)setHeightBottomConstrant:(MASConstraintMaker *)make view:(UIView *)view margin:(UIEdgeInsets)margin{
    if(view.gic_Height>0)
        make.height.mas_equalTo(view.gic_Height);
    else
        make.bottom.mas_offset(-margin.bottom);
}

-(void)setTopConstrant:(MASConstraintMaker *)make marginTop:(CGFloat)top{
    make.top.mas_offset(top);
}

-(void)elementParseCompelte{
    
}

@end
