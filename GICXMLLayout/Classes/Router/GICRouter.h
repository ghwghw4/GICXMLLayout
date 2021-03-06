//
//  GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import <Foundation/Foundation.h>
#import "GICXMLLayout.h"
#import "NSObject+GICRouter.h"
#import "GICRouterProtocol.h"
#import "GICPageRouterProtocol.h"
#import "GICPage.h"
@interface GICRouter : NSObject
+(void)regiterAllElements;

+(void)loadAPPFromPath:(NSString *)path;

+(void)loadPageFromPath:(NSString *)path withParseCompelete:(void (^)(GICPage *page))compelte;
@end
