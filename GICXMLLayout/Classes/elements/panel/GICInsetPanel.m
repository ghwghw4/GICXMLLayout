//
//  GICInsetPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "GICInsetPanel.h"
#import "GICEdgeConverter.h"

@implementation GICInsetPanel
+(NSString *)gic_elementName{
    return @"inset-panel";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInsetPanel *)target setValue:value forKey:@"inset"];
             }],
             };
}

-(BOOL)gic_parseOnlyOneSubElement{
    return true;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    if(self.subnodes.count==0)
        return [super layoutSpecThatFits:constrainedSize];
    ASInsetLayoutSpec *insetBox = [ASInsetLayoutSpec new];
    insetBox.insets = self.inset;
    insetBox.child = [self.subnodes firstObject];
    return insetBox;
}

@end
