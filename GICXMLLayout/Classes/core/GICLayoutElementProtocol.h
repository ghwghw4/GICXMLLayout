//
//  GICLayoutElementProtocol.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#ifndef GICLayoutElementProtocol_h
#define GICLayoutElementProtocol_h

#import "GICValueConverter.h"
#import "GICNSObjectExtensionProperties.h"

@class RACSignal;
/**
 元素基本信息协议
 事实上所有的NSOject都可以被作为元素被xml解析的
 */
@protocol GICLayoutElementProtocol <NSObject>
@required
+(NSString *)gic_elementName;
@optional
/**
 元素的扩展属性。这个属性主要是针对所有的NSObject对象扩展出来的属性。可以说是通用的属性。
 其他的NSObject的子类可以覆盖getter方法，自己实现该属性，从而可以取得自定义元素中所需的扩展属性功能
 */
@property (nonatomic,readonly)GICNSObjectExtensionProperties *gic_ExtensionProperties;

/**
 支持的属性转换器列表
 
 @return <#return value description#>
 */
+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs;

/**
 获取所有的子元素
 
 @return 子元素
 */
-(NSArray *)gic_subElements;

/**
 添加一个子元素
 
 @param subElement <#subElement description#>
 */
-(void)gic_addSubElement:(NSObject *)subElement;


/**
 获取父级元素
 */
-(NSObject *)gic_getSuperElement;

/**
 删除子元素
 
 @param subElements <#subElement description#>
 */
-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements;


/**
 创建一个双向绑定信号
 
 @param attributeName <#attributeName description#>
 */
-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withSignalBlock:(void (^)(RACSignal *signal))signalBlock;
@end


@class GDataXMLElement;
/**
 元素解析协议
 */
@protocol GICElementParserProtocol <GICLayoutElementProtocol>

/**
 开始解析元素本身

 @param element <#element description#>
 */
-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment;

/**
 开始解析子元素
 */
-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children;


/**
  解析子元素的时候，该子元素不存在，无法解析

 @param element <#element description#>
 @return 如果可以强制解析，那么返回解析后的子元素
 */
-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element;

/**
 是否只支持单个子元素
 
 @return 不实现本方法，或者返回YES，那么只能是单个子元素
 */
-(BOOL)gic_parseOnlyOneSubElement;

/**
 解析属性

 @param element <#element description#>
 */
-(void)gic_parseAttributes:(GDataXMLElement *)element;

/**
 解析完成
 */
-(void)gic_parseElementCompelete;

/**
 是否自动缓存节点。如果是，那么会自动缓存到subElements数组中。
 
 @return <#return value description#>
 */
-(BOOL)gic_isAutoCacheElement;
@end



#endif /* GICLayoutElementProtocol_h */
