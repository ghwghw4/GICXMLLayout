//
//  GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import <Foundation/Foundation.h>
#import "GICXMLLayout.h"
@interface GICRouter : NSObject
+(void)regiterAllElements;

//+(void)loadAPP:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *rootPage))compelte;

+(void)loadAPPFromPath:(NSString *)path withParseCompelete:(void (^)(UIViewController *rootPage))compelte;

//+(void)parsePage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte;

+(void)parsePageFromPath:(NSString *)path withParseCompelete:(void (^)(UIViewController *page))compelte;
@end
