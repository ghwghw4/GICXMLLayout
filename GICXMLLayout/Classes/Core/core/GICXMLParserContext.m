//
//  GICXMLParserContext.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICXMLParserContext.h"

@implementation GICXMLParserContext
-(id)initWithXMLDoc:(GDataXMLDocument *)xmlDoc{
    self = [super init];
    self->_xmlDoc = xmlDoc;
    _currentTemplates = [NSMutableDictionary dictionary];
    return self;
}

static GICXMLParserContext *current;
+(instancetype)currentInstance{
    return current;
}

+(void)resetInstance:(GDataXMLDocument *)xmlDoc{
    current = [[GICXMLParserContext alloc] initWithXMLDoc:xmlDoc];
}

+(void)parseCompelete{
    current = nil;
}
@end
