//
//  GICStackPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICStackPanel.h"
#import "GICBoolConverter.h"
#import "GICNumberConverter.h"

@implementation GICStackPanel
+(NSString *)gic_elementName{
    return @"stack-panel";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return @{
             @"is-horizon":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICStackPanel *)target).isHorizon = [value boolValue];
             }],
             @"justify-content":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"justifyContent"];
             }],
             @"align-items":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"alignItems"];
             }],
             @"space":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                    [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"spacing"];
             }],
             };
}

-(id)init{
    self = [super init];
    stackPanelPropertyDict = [NSMutableDictionary dictionary];
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASStackLayoutSpec *spec =self.isHorizon?[ASStackLayoutSpec horizontalStackLayoutSpec]:[ASStackLayoutSpec verticalStackLayoutSpec];
    spec.children = self.subnodes;
    if(self->stackPanelPropertyDict.count>0)
        [spec setValuesForKeysWithDictionary:self->stackPanelPropertyDict];
    return spec;
}

@end
