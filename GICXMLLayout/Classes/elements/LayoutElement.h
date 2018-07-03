//
//  LayoutElement.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#ifndef LayoutElement_h
#define LayoutElement_h

#import "GICValueConverter.h"
@class GDataXMLElement;

@protocol LayoutElementProtocol
@required
+(NSString *)gic_elementName;

@optional
+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters;


/**
 解析子元素
 */
-(void)gic_parseSubViews:(NSArray<GDataXMLElement *> *)children;

-(void)gic_elementParseCompelte;

-(CGFloat)gic_calcuActualHeight;
@end

#endif /* LayoutElement_h */
