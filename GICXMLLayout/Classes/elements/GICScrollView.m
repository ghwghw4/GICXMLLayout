//
//  GICScrollView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICScrollView.h"
#import <Masonry/Masonry.h>
#import "UIView+GICExtension.h"
#import "GICPanel.h"

@implementation GICScrollView
+(NSString *)gic_elementName{
    return @"scroll-view";
}

//-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
//    NSAssert(children.count <= 1, @"scroll-view只支持单个子元素");
//    if(children.count==1){
//        [super gic_parseSubElements:children];
//    }
//}
-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(void)gic_addSubElement:(id)subElement{
    NSAssert([subElement isKindOfClass:[GICPanel class]], @"scroll-view 的子元素必须是panel及其子类");
    if([subElement isKindOfClass:[GICPanel class]]){
        [super gic_addSubElement:subElement];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIView *v =[self.subviews firstObject];
    if(v){
        UIEdgeInsets margin = v.gic_margin;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(margin.left);
            make.top.mas_offset(margin.top);
            make.bottom.mas_offset(-margin.bottom);
            make.width.mas_equalTo(self.frame.size.width);
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
