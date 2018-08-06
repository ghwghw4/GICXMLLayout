//
//  GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import <Foundation/Foundation.h>
#import "GICXMLLayout.h"
#import "NSObject+GICRouter.h"
@interface GICRouter : NSObject
+(void)regiterAllElements;

+(void)loadAPPFromPath:(NSString *)path withParseCompelete:(void (^)(UIViewController *rootPage))compelte;

+(void)parsePageFromPath:(NSString *)path withParseCompelete:(void (^)(UIViewController *page))compelte;
@end
