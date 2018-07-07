//
//  GICTemplateSlot.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICTemplateSlot.h"
#import "GICStringConverter.h"

@implementation GICTemplateSlot
+(NSString *)gic_elementName{
    return @"template-slot";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"slot-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICTemplateSlot *)target setSlotName:value];
             }]
             };;
}
@end
