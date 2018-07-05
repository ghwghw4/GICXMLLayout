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
// 双向绑定中value改变的事件
typedef void (^GICTowWayBindingValueChanged)(id newValue);

@protocol LayoutElementProtocol
@required
+(NSString *)gic_elementName;

@optional
+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters;


/**
 解析子元素
 */
-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children;

/**
 获取所有的子元素

 @return 子元素
 */
-(NSArray *)gic_subElements;

-(void)gic_elementParseCompelte;

-(CGFloat)gic_calcuActualHeight;


#pragma mark binding相关
/**
 创建双向绑定

 @param attributeName <#attributeName description#>
 @param valueChanged <#valueChanged description#>
 */
-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withValueChangedCallback:(GICTowWayBindingValueChanged)valueChanged;
@end

#endif /* LayoutElement_h */
