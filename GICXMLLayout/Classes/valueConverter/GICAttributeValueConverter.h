//
//  GICPropertyConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>

typedef void (^GICPropertySetter)(NSObject *target,id value);
@interface GICAttributeValueConverter : NSObject
@property (nonatomic,copy)GICPropertySetter propertySetter;
//-(id)initWithName:(NSString *)name;
-(id)initWithPropertySetter:(GICPropertySetter)propertySetter;
-(id)convert:(NSString *)stringValue;

-(id)convertAnimationValue:(id)from to:(id)to per:(CGFloat)per;
@end
