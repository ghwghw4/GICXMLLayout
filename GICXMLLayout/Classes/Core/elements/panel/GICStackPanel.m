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

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"is-horizon":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICStackPanel *)target).isHorizon = [value boolValue];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return @(((GICStackPanel *)target).isHorizon);
             }],
             @"justify-content":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"justifyContent"];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return [((GICStackPanel *)target)->stackPanelPropertyDict valueForKey:@"justifyContent"];
             }],
             @"align-items":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"alignItems"];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return [((GICStackPanel *)target)->stackPanelPropertyDict valueForKey:@"alignItems"];
             }],
             @"space":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"spacing"];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return [((GICStackPanel *)target)->stackPanelPropertyDict valueForKey:@"spacing"];
             }],
             @"wrap":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"flexWrap"];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return [((GICStackPanel *)target)->stackPanelPropertyDict valueForKey:@"flexWrap"];
             }],
             @"align-content":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"alignContent"];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return [((GICStackPanel *)target)->stackPanelPropertyDict valueForKey:@"alignContent"];
             }],
             @"line-space":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICStackPanel *)target)->stackPanelPropertyDict setValue:value forKey:@"lineSpacing"];
                 [((GICStackPanel *)target) updateLayout];
             } withGetter:^id(id target) {
                 return [((GICStackPanel *)target)->stackPanelPropertyDict valueForKey:@"lineSpacing"];
             }],
             };
}

-(id)init{
    self = [super init];
    stackPanelPropertyDict = [NSMutableDictionary dictionary];
    return self;
}

-(void)updateLayout{
    if(self.nodeLoaded){
        [self setNeedsLayout];
    }
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASStackLayoutSpec *spec =self.isHorizon?[ASStackLayoutSpec horizontalStackLayoutSpec]:[ASStackLayoutSpec verticalStackLayoutSpec];
    spec.children = self.gic_displayNodes;
    if(self->stackPanelPropertyDict.count>0)
        [spec setValuesForKeysWithDictionary:self->stackPanelPropertyDict];
    return spec;
}

@end
