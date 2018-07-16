//
//  GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NSObject+GICDataContext.h"
#import "GICEventInfo.h"
#import "GICBehavior.h"
#import "GICElementsCache.h"
#import "GICLayoutElementProtocol.h"

@interface GICXMLLayout : NSObject
+(void)regiterAllElements;

//+(Class)classFromElementName:(NSString *)elementName;

+(NSObject *)createElement:(GDataXMLElement *)element withSuperElement:(id)superElement;


+(void)parseLayoutView:(NSData *)xmlData toView:(UIView *)superView withParseCompelete:(void (^)(UIView *view))compelte;

/**
 直接解析一个page

 @param xmlData <#xmlData description#>
 @param compelte <#compelte description#>
 */
+(void)parseLayoutPage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte;
@end
