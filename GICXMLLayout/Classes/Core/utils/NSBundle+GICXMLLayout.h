//
//  NSBundle+GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import <Foundation/Foundation.h>

@interface NSBundle (GICXMLLayout)
+ (instancetype)GICXMLLayoutBundle;

+(NSString *)gic_jsCoreString;

+(NSString *)gic_jsNativeAPIString;
@end
