//
//  GICLayoutUtils.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/12.
//

#import <Foundation/Foundation.h>

@interface GICLayoutUtils : NSObject
/**
 ASDisplayNode通用的属性转换器
 
 @return <#return value description#>
 */
+(NSDictionary<NSString *,GICValueConverter *> *)commonPropertyConverters;
@end
