//
//  NSObject+LayoutView.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import <Foundation/Foundation.h>
#import "GICNSObjectExtensionProperties.h"

@interface NSObject (LayoutElement)<GICElementParserProtocol>
/**
 元素的扩展属性。这个属性主要是针对所有的NSObject对象扩展出来的属性。可以说是通用的属性。
 其他的NSObject的子类可以覆盖getter方法，自己实现该属性，从而可以取得自定义元素中所需的扩展属性功能
 */
@property (nonatomic,readonly)GICNSObjectExtensionProperties *gic_ExtensionProperties;
@end
