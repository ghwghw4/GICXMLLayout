//
//  GICStackPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICStackPanel.h"
#import <Masonry/Masonry.h>

@interface NSAttributedString (Additions)
+ (NSAttributedString *)attributedStringWithString:(NSString *)string fontSize:(CGFloat)size color:(UIColor *)color;
@end


@implementation NSAttributedString (Additions)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string fontSize:(CGFloat)size color:(nullable UIColor *)color
{
    if (string == nil) {
        return nil;
    }
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: color ? : [UIColor blackColor],
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:size]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
    
    return attributedString;
}

@end


@implementation UIColor (Additions)

+ (UIColor *)darkBlueColor
{
    return [UIColor colorWithRed:18.0/255.0 green:86.0/255.0 blue:136.0/255.0 alpha:1.0];
}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

@end


@implementation GICStackPanel
+(NSString *)gic_elementName{
    return @"stack-panel";
}

-(id)init{
    ASStackLayoutSpec *nameLocationStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    self = [super initWithLayoutSpec:nameLocationStack];
    
    
    nameLocationStack.style.flexShrink = 1.0;
    nameLocationStack.style.flexGrow = 1.0;
    
    _usernameNode = [[ASTextNode alloc] init];
    _usernameNode.attributedText = [NSAttributedString attributedStringWithString:@"hannahmbanadsdna"
                                                                         fontSize:20
                                                                            color:[UIColor darkBlueColor]];
    _usernameNode.maximumNumberOfLines = 1;
    _usernameNode.truncationMode = NSLineBreakByTruncatingTail;
    
    _postLocationNode = [[ASTextNode alloc] init];
    _postLocationNode.maximumNumberOfLines = 1;
    _postLocationNode.attributedText = [NSAttributedString attributedStringWithString:@"Sunset 以已搞丢噶丢给撒UI都干撒U的噶速度国赛U的公司Beach, dasdsassdasdsadsadasdasdasdsaSan Fransisco, CA"
                                                                             fontSize:20
                                                                                color:[UIColor lightBlueColor]];
    _postLocationNode.maximumNumberOfLines = 2;
    _postLocationNode.truncationMode = NSLineBreakByTruncatingTail;
//    _postLocationNode.maximumNumberOfLines = 1;
//    _postLocationNode.truncationMode = NSLineBreakByTruncatingTail;
    
    nameLocationStack.children = @[_usernameNode, _postLocationNode];
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    return self.layoutSpec;
}
//-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
//    [super gic_removeSubElements:subElements];
//    // 删除后重新计算布局
//    for(UIView *v in self.subviews){
//        [self gic_LayoutSubView:v];
//    }
//}


//-(void)gic_LayoutSubView:(UIView *)view{
//    UIEdgeInsets margin = view.gic_ExtensionProperties.margin;
//    UIView *preView = nil;
//    NSInteger index = [self.subviews indexOfObject:view];
//    if(index>0){
//        preView = [self.subviews objectAtIndex:index-1];
//    }
//    GICViewExtensionProperties *viewExtensionProperties = view.gic_ExtensionProperties;
//    NSAssert(viewExtensionProperties.height>0 || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[GICPanel class]] , @"stackpanel 所有的元素(除了lable、panel)都必须显示设置高度");
//
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        // left
//        make.left.mas_offset(margin.left);
//        // top
//        if(preView){
//            make.top.mas_equalTo(preView.mas_bottom).mas_offset(margin.top + preView.gic_ExtensionProperties.margin.bottom);
//        }else{
//            make.top.mas_offset(margin.top);
//        }
//        // height
//        if(viewExtensionProperties.height>0)
//            make.height.mas_equalTo(viewExtensionProperties.height);
//
//        // width
//        if(viewExtensionProperties.width > 0)
//            make.width.mas_equalTo(viewExtensionProperties.width);
//        else
//            make.right.mas_offset(-margin.right);
//    }];
//}

//-(CGFloat)gic_calcuActualHeight{
//    [self setNeedsLayout];
//    if(self.subviews.count==0)
//        return self.frame.size.height;
//    UIView *lastSubview = [self.subviews lastObject];
////    UIEdgeInsets margin = self.gic_ExtensionProperties.margin;
//    return CGRectGetMaxY(lastSubview.frame) + lastSubview.gic_ExtensionProperties.margin.bottom;
//}
@end
