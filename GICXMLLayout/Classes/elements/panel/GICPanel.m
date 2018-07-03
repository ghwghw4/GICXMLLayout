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
    CGFloat maxHeight  = 0;
    for(UIView *v in self.subviews){
        maxHeight = MAX(maxHeight, CGRectGetMaxY(v.frame) + v.gic_margin.bottom);
    }
    return maxHeight;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h = 0;
    if(self.gic_Height>0){
        h = self.gic_Height;
    }else{
         h = [self calcuActualHeight];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
}

-(void)addSubview:(UIView *)view{
    [super addSubview:view];
    [self layoutView:view];
}

-(void)layoutView:(UIView *)view{
    UIEdgeInsets margin = view.gic_margin;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(margin.left);
         make.top.mas_offset(margin.top);
        
        if(view.gic_Height>0)
            make.height.mas_equalTo(view.gic_Height);
        else{
            if(margin.bottom!=0 || ![view isKindOfClass:[UILabel class]]){
                make.bottom.mas_offset(-margin.bottom);
            }
        }
        
        
        
        
        if(view.gic_Width > 0)
            make.width.mas_equalTo(view.gic_Width);
        else
            make.right.mas_offset(-margin.right);
    }];
}


-(void)elementParseCompelte{
    
}

@end
