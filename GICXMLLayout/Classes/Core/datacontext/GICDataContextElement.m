//
//  GICDataContextElement.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/8.
//

#import "GICDataContextElement.h"

@implementation GICDataContextElement
+(NSString *)gic_elementName{
    return @"data-context";
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    [super gic_beginParseElement:element withSuperElement:superElment];
    NSString *jsonString = [element stringValueOrginal];
    if(jsonString && jsonString.length>0){
        id obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if(obj){
            [superElment gic_ExtensionProperties].tempDataContext =obj;
        }
    }
}
@end
