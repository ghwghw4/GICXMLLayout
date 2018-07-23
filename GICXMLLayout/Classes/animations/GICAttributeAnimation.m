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
                 ((GICAttributeAnimation *)target)->_fromString = value;
             }],
             @"to":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICAttributeAnimation *)target)->_toString = value;
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
    
    fromValue = [valueConverter convert:self.fromString];
    toValue = [valueConverter convert:self.toString];
}

-(POPAnimation *)createAnimation{
    @weakify(self)
    POPAnimatableProperty *prop =  [POPAnimatableProperty propertyWithName:@"GICXMLLayout" initializer:^(POPMutableAnimatableProperty *prop) {
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            @strongify(self)
            id value = [self->valueConverter convertAnimationValue:self->fromValue to:self->toValue per:values[0] / 100.0];
            self->valueConverter.propertySetter(self.target, value);
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(0);
    anBasic.toValue = @(100);
    return anBasic;
}
@end
