//
//  LayoutElement.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#ifndef LayoutElement_h
#define LayoutElement_h

#import "GICValueConverter.h"

@protocol LayoutElementProtocol
@required
+(NSString *)gic_elementName;

@optional
+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters;

-(void)elementParseCompelte;
@end

#endif /* LayoutElement_h */
