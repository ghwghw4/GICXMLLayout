//
//  GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "NSObject+GICDataContext.h"
#import <GDataXMLNode_GIC/GDataXMLNode.h>
#import "GICEventInfo.h"
#import "GICBehavior.h"
#import "NSObject+LayoutElement.h"
#import "GICDataBingdingValueConverter.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "NSObject+GICEvent.h"
#import "GICElementsHelper.h"
#import "NSValue+GICXMLLayout.h"

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


#pragma mark 加载数据
+(NSData *)loadDataFromPath:(NSString *)path;
+(NSData *)loadDataFromUrl:(NSURL *)url;

/**
 清空文件缓存
 */
+(void)clearAllCache;

#pragma mark 解析

/**
 设置跟路径

 @param rootUrl <#rootUrl description#>
 */
+(void)setRootUrl:(NSString *)rootUrl;
+(NSString *)rootUrl;

#pragma mark 同步解析
+(id)parseElementFromUrl:(NSURL *)url withParentElement:(id)parentElement;
+(id)parseElementFromPath:(NSString *)path withParentElement:(id)parentElement;
+(id)parseElementFromData:(NSData *)xmlData withParentElement:(id)parentElement;

#pragma mark 异步解析
+(void)parseElementFromUrlAsync:(NSURL *)url withParentElement:(id)parentElement withParseCompelete:(void (^)(id element))compelte;
+(void)parseElementFromPathAsync:(NSString *)path withParentElement:(id)parentElement withParseCompelete:(void (^)(id element))compelte;


/**
 解析视图。确保xml中的根节点是UI元素。

 @param xmlData <#xmlData description#>
 @param superView <#superView description#>
 @param compelte <#compelte description#>
 */
+(void)parseLayoutView:(NSData *)xmlData toView:(UIView *)superView withParseCompelete:(void (^)(UIView *view))compelte;

+(void)parseLayoutViewWithPath:(NSString *)path toView:(UIView *)superView withParseCompelete:(void (^)(UIView *view))compelte;
@end
