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
                             [(GICInpute *)target setText:value];
                         }],
                         };
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withValueChangedCallback:(GICTowWayBindingValueChanged)valueChanged{
    if([attributeName isEqualToString:@"text"]){
        [[self rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            valueChanged(x);
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end