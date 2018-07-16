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

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return @{
             @"placehold":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setPlaceholder:value];
                 }];
             }],
             @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setText:value];
                 }];
             }],
             @"secure":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setSecureTextEntry:[value boolValue]];
                 }];
             }],
             };
}

-(id)init{
    self = [super init];
    [self setViewBlock:^UIView * _Nonnull{
        return [UITextField new];
    }];
    self.style.height = ASDimensionMake(31);//默认高度31
    return self;
}


-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withSignalBlock:(void (^)(RACSignal *))signalBlock{
    if([attributeName isEqualToString:@"text"]){
        [self gic_safeView:^(UIView *view) {
            signalBlock([(UITextField *)view rac_textSignal]);
        }];
    }
}
@end
