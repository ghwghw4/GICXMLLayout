//
//  ASDisplayNodeUtiles.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import <Foundation/Foundation.h>

@interface ASDisplayNodeUtiles : NSObject

/**
 ASDisplayNode通用的属性转换器

 @return <#return value description#>
 */
+(NSDictionary<NSString *,GICValueConverter *> *)commonPropertyConverters;
@end
