//
//  GICRatioPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/20.
//

#import "GICRatioPanel.h"
#import "GICNumberConverter.h"

@implementation GICRatioPanel

+(NSString *)gic_elementName{
    return @"ratio-panel";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"ratio":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 CGFloat v = [value floatValue];
                 v = MAX(v, 0);
                 ((GICRatioPanel *)target).ratio = v;
             }],
             };
}

-(id)init{
    self = [super init];
    self.ratio = 1;
    return self;
}
-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        NSAssert(self.subnodes.count == 0, @"ratio-panel只能有一个子元素");
    }
    return [super gic_addSubElement:subElement];
}

-(void)setRatio:(CGFloat)ratio{
    _ratio = ratio;
    if(self.nodeLoaded){
        [self setNeedsLayout];
    }
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSArray *nodes = self.gic_displayNodes;
    if(nodes.count==0)
        return [super layoutSpecThatFits:constrainedSize];
    ASRatioLayoutSpec *rationSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:self.ratio child:nodes.firstObject];
    return rationSpec;
}
@end
