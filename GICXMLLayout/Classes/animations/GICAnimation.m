//
//  GICAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICAnimation.h"
#import "GICStringConverter.h"

@implementation GICAnimation
+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return @{
             @"from":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_fromValue = value;
             }],
             @"to":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAnimation *)target)->_toValue = value;
             }],
             };;
}

-(id)init{
    self  = [super init];
    animation = [self createAnimation];
    return self;
}

-(POPAnimation *)createAnimation{
    return nil;
}
@end
