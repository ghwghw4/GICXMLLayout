//
//  GICPropertyConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "GICValueConverter.h"

typedef void (^GICPropertySetter)(NSObject *target,id value);

typedef id (^GICPropertyGetter)(id target);

@interface GICAttributeValueConverter : GICValueConverter

#pragma mark setter
@property (nonatomic,copy)GICPropertySetter propertySetter;
-(id)convert:(NSString *)stringValue;
-(id)convertAnimationValue:(id)from to:(id)to per:(CGFloat)per;

#pragma mark getter
@property (nonatomic,copy)GICPropertyGetter propertyGetter;
-(NSString *)valueToString:(id)value;


#pragma mark init
-(id)initWithPropertySetter:(GICPropertySetter)propertySetter;
-(id)initWithPropertySetter:(GICPropertySetter)propertySetter withGetter:(GICPropertyGetter)propertyGetter;
@end
