//
//  GICXMLParserContext.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>

/**
 解析上下文.临时的。 解析完毕就会释放.采用链表结构存储。
 */
@interface GICXMLParserContext : NSObject
@property (nonatomic,strong,readonly)GDataXMLDocument *xmlDoc;
@property (nonatomic,strong,readonly)NSMutableDictionary *currentTemplates;

-(id)initWithXMLDoc:(GDataXMLDocument *)xmlDoc;

/**
 获取链表最顶端的实例

 @return <#return value description#>
 */
+(instancetype)currentInstance;

+(void)resetInstance:(GDataXMLDocument *)xmlDoc;

+(void)parseCompelete;
@end
