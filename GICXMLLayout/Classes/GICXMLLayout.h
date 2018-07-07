//
//  GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NSObject+GICDataContext.h"

@interface GICXMLLayout : NSObject
+(void)regiterAllElements;

//+(Class)classFromElementName:(NSString *)elementName;

+(NSObject *)createElement:(GDataXMLElement *)element;


+(void)parseLayout:(NSData *)xmlData toView:(UIView *)superView withParseCompelete:(void (^)(UIView *view))compelte;
@end
