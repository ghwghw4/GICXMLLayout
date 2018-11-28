//
//  GICScrollView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICScrollView.h"
#import "GICPanel.h"
#import "GICBoolConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"

@implementation GICScrollView
+(NSString *)gic_elementName{
    return @"scroll-view";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICScrollView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsVerticalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICScrollView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsHorizontalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"content-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICScrollView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setValue:value forKey:@"contentInset"];
                 }];
             }],
             
             @"content-inset-behavior":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 if (@available(iOS 11.0, *)) {
                     [(GICScrollView *)target gic_safeView:^(UIView *view) {
                         [(UIScrollView *)view setContentInsetAdjustmentBehavior:[value integerValue]];
                     }];
                 }
             }],
             };;
}

-(id)init{
    self =[super init];
    self.automaticallyManagesSubnodes = YES;
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *temp = [ASStackLayoutSpec verticalStackLayoutSpec];
    temp.children = self.gic_displayNodes;
    return temp;
}

-(void)layout{
    [super layout];
    // NOTE: Texture在计算布局的时候，默认将内容的最小高度设置为scrollnode  frame的高度，因此如果scrollview是VC中的第一个view的时候，iOS会自动添加一个内边距，self.view.adjustedContentInset ,这时候如果内容的高度没有超过scriollview 的高度的时候，总是会有一个滚动条出现，很恶心。下面的代码就是自己计算scrollview的contentSize来达到避免这个问题的出现
    ASDisplayNode *lastnode = self.subnodes.lastObject;
    if(lastnode){
        self.view.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(lastnode.frame));
    }
}
@end
