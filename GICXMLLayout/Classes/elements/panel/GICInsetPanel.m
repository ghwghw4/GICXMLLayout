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
+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInsetPanel *)target setValue:value forKey:@"inset"];
             }],
             //             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
             //                 [((GICPage *)target)->viewNode setBackgroundColor:value];
             //             }],
             };
}

-(BOOL)gic_parseOnlyOneSubElement{
    return true;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    id node =self.childNodes.firstObject;
    if([node isKindOfClass:[GICPanel class]]){
        node = [node layoutSpecThatFits:constrainedSize];
    }
    ASInsetLayoutSpec *insetBox = [ASInsetLayoutSpec new];
    insetBox.insets = self.inset;
    insetBox.child = node;
    return insetBox;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
