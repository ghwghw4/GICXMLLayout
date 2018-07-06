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
@class RACSignal;
// 双向绑定中value改变的事件
//typedef void (^GICTowWayBindingValueChanged)(id newValue);

@protocol LayoutElementProtocol
@required
+(NSString *)gic_elementName;

@optional
+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters;

#pragma mark 子元素解析相关
/**
 解析子元素
 */
-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children;

/**
 获取所有的子元素

 @return 子元素
 */
-(NSArray *)gic_subElements;

-(void)gic_addSubElement:(NSObject *)subElement;

/**
 是否支持单个子元素

 @return 不实现本方法，或者返回YES，那么只能是单个子元素
 */
-(BOOL)gic_parseOnlyOneSubElement;





-(CGFloat)gic_calcuActualHeight;


#pragma mark binding相关
/**
 创建双向绑定

 @param attributeName <#attributeName description#>
 @param valueChanged <#valueChanged description#>
 */
-(RACSignal *)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName;



-(void)gic_elementParseCompelte;
@end

#endif /* LayoutElement_h */
