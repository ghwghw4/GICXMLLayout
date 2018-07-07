//
//  GICXMLParserContext.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>

/**
 解析上下文.临时的。 解析完毕就会释放
 */
@interface GICXMLParserContext : NSObject
@property (nonatomic,strong,readonly)GDataXMLDocument *xmlDoc;
@property (nonatomic,strong,readonly)NSMutableDictionary *currentTemplates;

-(id)initWithXMLDoc:(GDataXMLDocument *)xmlDoc;

+(instancetype)currentInstance;

+(void)resetInstance:(GDataXMLDocument *)xmlDoc;

+(void)parseCompelete;
@end
