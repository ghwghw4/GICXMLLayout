//
//  GICPropertyConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICAttributeValueConverter.h"

@implementation GICAttributeValueConverter
-(id)convertAnimationValue:(id)from to:(id)to per:(CGFloat)per{
    return nil;
}

-(id)initWithPropertySetter:(GICPropertySetter)propertySetter{
    self = [super init];
    self.propertySetter  = propertySetter;
    return self;
}

-(id)initWithPropertySetter:(GICPropertySetter)propertySetter withGetter:(GICPropertyGetter)propertyGetter{
    self = [super init];
    self.propertySetter  = propertySetter;
    self.propertyGetter = propertyGetter;
    return self;
}

-(id)initWithPropertySetter:(GICPropertySetter)propertySetter withGetter:(GICPropertyGetter)propertyGetter withDefualtValue:(id)defualtValue{
    self = [self initWithPropertySetter:propertySetter withGetter:propertyGetter];
    _defualtValue = defualtValue;
    return self;
}

-(id)initWithName:(NSString *)name withSetter:(GICPropertySetter)propertySetter{
    self = [self initWithPropertySetter:propertySetter];
    self.name = name;
    return self;
}

-(NSString *)valueToString:(id)value{
    return nil;
}

-(id)convert:(NSString *)stringValue{
    return nil;
}
@end
