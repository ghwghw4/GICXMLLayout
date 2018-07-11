//
//  GICPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICPanel.h"
#import "UIView+GICExtension.h"
#import "GICXMLLayout.h"
#import "GICDirective.h"


@implementation GICPanel
+(NSString *)gic_elementName{
    return @"panel";
}

//-(id)init{
//    self = [super init];
//    return self;
//}

-(id)initWithLayoutSpec:(ASLayoutSpec *)layoutSpec{
    self = [super init];
    self.automaticallyManagesSubnodes = YES;
    _layoutSpec = layoutSpec;
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    return self.layoutSpec;
}

//-(CGFloat)gic_calcuActualHeight{
//    [self setNeedsLayout];//必须添加这样代码，确保在计算子元素高度的时候，子元素已经正确计算，但是这样一来肯定会有性能影响。
//    CGFloat maxHeight  = 0;
//    if(self.subviews.count==0)
//        maxHeight =  self.gic_ExtensionProperties.height;
//    else{
//        for(UIView *v in self.subviews){
//            if([v respondsToSelector:@selector(gic_calcuActualHeight)]){
//                maxHeight = [(id)v gic_calcuActualHeight] + v.gic_ExtensionProperties.margin.bottom + v.gic_ExtensionProperties.margin.top;
//            }else{
//                maxHeight = MAX(maxHeight, CGRectGetMaxY(v.frame) + v.gic_ExtensionProperties.margin.bottom);
//            }
//        }
//    }
//    UIEdgeInsets margin = self.gic_ExtensionProperties.margin;
//    return maxHeight + margin.top + margin.bottom;
//}
//
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    if(self.subviews.count>0){
//        CGFloat h = 0;
//        if(self.gic_ExtensionProperties.height>0){
//            h = self.gic_ExtensionProperties.height;
//        }else{
//            h = [self gic_calcuActualHeight];
//        }
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(h);
//        }];
//    }
//}
//
//-(void)addSubview:(UIView *)view{
//    [super addSubview:view];
//    [self gic_LayoutSubView:view];
//}
//
//-(void)gic_LayoutSubView:(UIView *)view{
//    UIEdgeInsets margin = view.gic_ExtensionProperties.margin;
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(margin.left);
//        make.top.mas_offset(margin.top);
//
//        if(view.gic_ExtensionProperties.height>0)
//            make.height.mas_equalTo(view.gic_ExtensionProperties.height);
//        else{
//            // NOTE:对于UILabel来说，不会设置bottom，否则采用自适应高度的方式
//            if(![view isKindOfClass:[UILabel class]]){
//                make.bottom.mas_offset(-margin.bottom);
//            }else{
//                if(margin.bottom!=0){
//                    make.bottom.mas_offset(-margin.bottom);
//                }
//            }
//        }
//
//        if(view.gic_ExtensionProperties.width > 0)
//            make.width.mas_equalTo(view.gic_ExtensionProperties.width);
//        else
//            make.right.mas_offset(-margin.right);
//    }];
//}
@end
