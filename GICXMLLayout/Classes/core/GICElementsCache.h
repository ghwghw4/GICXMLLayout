//
//  GICElementsCache.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/14.
//

#import <Foundation/Foundation.h>

@interface GICElementsCache : NSObject
#pragma mark element 相关
+(void)registElement:(Class)elementClass;
+(Class)classForElementName:(NSString *)elementName;

#pragma mark attribute 相关
// 对某个元素注入属性
+(BOOL)injectAttributes:(NSDictionary<NSString *,GICValueConverter *> *)attributs forElementName:(NSString *)elementName;

/**
 获取某个class的已经所有可支持属性

 @param klass <#klass description#>
 @return <#return value description#>
 */
+(NSDictionary<NSString *, GICValueConverter *> *)classAttributs:(Class)klass;
@end
