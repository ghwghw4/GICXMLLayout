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

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertyConverters{
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
//    stackLayoutSpec = [[ASStackLayoutSpec alloc] init];
//    stackLayoutSpec.direction = ASStackLayoutDirectionVertical;
    stackPanelPropertyDict = [NSMutableDictionary dictionary];
    return self;
}

-(void)mergeStyle:(ASLayoutSpec *)spec{
    [super mergeStyle:spec];
    if(self->stackPanelPropertyDict.count>0)
        [spec setValuesForKeysWithDictionary:self->stackPanelPropertyDict];
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize withChildren:(NSArray *)children{
    ASStackLayoutSpec *temp =self.isHorizon?[ASStackLayoutSpec horizontalStackLayoutSpec]:[ASStackLayoutSpec verticalStackLayoutSpec];
    temp.children = children;
    return temp;
}

@end
