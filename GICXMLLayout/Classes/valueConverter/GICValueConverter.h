//
//  GICPropertyConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>

typedef void (^GICPropertySetter)(NSObject *target,id value);
@interface GICValueConverter : NSObject
@property (nonatomic,copy)GICPropertySetter propertySetter;
//-(id)initWithName:(NSString *)name;
-(id)initWithPropertySetter:(GICPropertySetter)propertySetter;
-(id)convert:(NSString *)xmlStringValue;

//-(void)setProperty:(UIView *)view withXMLStringValue:(NSString *)xmlStringValue;
@end
