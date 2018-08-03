//
//  GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
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


/**
 是否启用默认样式的解析。默认不启用
 如果启用的话，那么你可以在style中为元素定义默认的属性。无需指定"style-name"。
 定以后会自动应用到该节点下的所有子元素的上面。

 @param enable <#enable description#>
 */
+(void)enableDefualtStyle:(BOOL)enable;

+(void)setRootUrl:(NSString *)rootUrl;
+(NSString *)rootUrl;

+(void)parseElementFromUrl:(NSURL *)url withParentElement:(id)parentElement withParseCompelete:(void (^)(id element))compelte;

+(void)parseElementFromPath:(NSString *)path withParentElement:(id)parentElement withParseCompelete:(void (^)(id element))compelte;


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
