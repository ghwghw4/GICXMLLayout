//
//  GICAttributeAnimation.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICAttributeAnimation.h"
#import "GICStringConverter.h"
#import "GICElementsCache.h"

@implementation GICAttributeAnimation
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"from":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAttributeAnimation *)target)->fromString = value;
             }],
             @"to":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAttributeAnimation *)target)->toString = value;
             }],
             @"attribute-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAttributeAnimation *)target)->_atttibuteName = value;
             }],
             };;
}

+(NSString *)gic_elementName{
    return @"anim-attribute";
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    NSDictionary<NSString *, GICAttributeValueConverter *> * atts=[GICElementsCache classAttributs:[target class]];
    valueConverter = [atts objectForKey:self.atttibuteName];
    
}

-(POPAnimatableProperty *)createAnimatableProperty{
    _fromValue = [valueConverter convert:self->fromString];
    _toValue = [valueConverter convert:self->toString];
    @weakify(self)
    POPAnimatableProperty *prop =  [POPAnimatableProperty propertyWithName:@"GICXMLLayout" initializer:^(POPMutableAnimatableProperty *prop) {
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            @strongify(self)
            id value = [self->valueConverter convertAnimationValue:self.fromValue to:self.toValue per:values[0] / 100.0];
            self->valueConverter.propertySetter(self.target, value);
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    return prop;
}
@end
