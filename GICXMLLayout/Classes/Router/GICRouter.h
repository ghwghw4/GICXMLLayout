//
//  GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import <Foundation/Foundation.h>

@interface GICRouter : NSObject
+(void)regiterAllElements;

+(void)loadAPP:(NSData *)xmlData;
+(void)parsePage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte;
@end
