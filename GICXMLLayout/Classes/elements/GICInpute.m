//
//  GICInpute.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/5.
//

#import "GICInpute.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "GICBoolConverter.h"

@implementation GICInpute
+(NSString *)gic_elementName{
    return @"input";
}

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"placehold":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(GICInpute *)target setPlaceholder:value];
                         }],
                         @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             GICInpute *inpute = (GICInpute *)target;
                             if(![value isEqual:inpute.text]){
                                 [(GICInpute *)target setText:value];
                             }
                         }],
                         @"secure":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             GICInpute *inpute = (GICInpute *)target;
                             [inpute setSecureTextEntry:[value boolValue]];
                         }],
                         };
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return propertyConverts;
}

-(RACSignal *)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName{
    if([attributeName isEqualToString:@"text"]){
        return [self rac_textSignal];
    }
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
