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
#import "GICDataBingdingValueConverter.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GICEvent.h"

@interface GICXMLLayout : NSObject

/**
 注册所有的元素
 */
+(void)regiterAllElements;

/**
 注册核心元素
 */
+(void)regiterCoreElements;

/**
 注册UI元素
 */
+(void)regiterUIElements;


//+(Class)classFromElementName:(NSString *)elementName;



/**
 解析视图。确保xml中的根节点是UI元素。

 @param xmlData <#xmlData description#>
 @param superView <#superView description#>
 @param compelte <#compelte description#>
 */
+(void)parseLayoutView:(NSData *)xmlData toView:(UIView *)superView withParseCompelete:(void (^)(UIView *view))compelte;

/**
 直接解析一个page。确保xml中的根节点是page
 @param xmlData <#xmlData description#>
 @param compelte <#compelte description#>
 */
+(void)parseLayoutPage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte;
@end
