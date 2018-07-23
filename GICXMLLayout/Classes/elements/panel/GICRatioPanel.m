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
-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        NSAssert(self.subnodes.count == 0, @"ratio-panel只能有一个子元素");
    }
    [super gic_addSubElement:subElement];
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    if(self.subnodes.count==0)
        return [super layoutSpecThatFits:constrainedSize];
    ASRatioLayoutSpec *rationSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:self.ratio child:self.subnodes.firstObject];
    return rationSpec;
}
@end
