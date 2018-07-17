//
//  SwitchButton.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/16.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "SwitchButton.h"
#import "GICBoolConverter.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation SwitchButton
+(NSString *)gic_elementName{
    return @"switch-button";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return @{
             @"checked":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [((SwitchButton *)target).view setOn:[value boolValue]];
                 });
             }],
             };
}

-(id)init{
    self = [super init];
    __weak typeof (self) wself = self;
    [self setViewBlock:^UIView * _Nonnull{
        UISwitch *swicth= [[UISwitch alloc] init];
        [swicth sizeToFit];
        wself.style.width = ASDimensionMake(swicth.frame.size.width);
        wself.style.height = ASDimensionMake(swicth.frame.size.height);
        return swicth;
    }];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withSignalBlock:(void (^)(RACSignal *))signalBlock{
    signalBlock([self.view rac_newOnChannel]);
}

//-(RACSignal *)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName{
//    return [self.view rac_newOnChannel];
//}
@end
