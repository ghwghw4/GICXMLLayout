//
//  GICLayoutElementProtocol.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#ifndef GICLayoutElementProtocol_h
#define GICLayoutElementProtocol_h

#import "GICAttributeValueConverter.h"
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
 支持的属性转换器列表
 
 @return <#return value description#>
 */
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs;

/**
 获取所有的子元素
 
 @return 子元素
 */
-(NSArray *)gic_subElements;


/**
  添加一个子元素

 @param subElement <#subElement description#>
 @return 返回实际被添加的子元素。主要是有了模板以后，实际被添加的子元素未必就是传入的子元素。
 */
-(id)gic_addSubElement:(id)subElement;

-(id)gic_insertSubElement:(id)subElement elementOrder:(NSInteger)order;


/**
 获取父级元素
 */
-(id)gic_getSuperElement;

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


/**
 通过name获取子元素

 @param name <#name description#>
 @return <#return value description#>
 */
-(id)gic_findSubElementFromName:(NSString *)name;
@end



#endif /* GICLayoutElementProtocol_h */
