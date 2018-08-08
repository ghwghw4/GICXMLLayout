//
//  UtilsHelp.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/9.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "UtilsHelp.h"
#import "GICXMLLayout.h"

@implementation UtilsHelp
+(void)navigateToGICPage:(NSString *)pagePath{
    NSData *xmlData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@.xml",pagePath]];
//    [GICXMLLayout parseLayoutPage:xmlData withParseCompelete:^(UIViewController *page) {
//        UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication] delegate].window.rootViewController;
//        [nav pushViewController:page animated:YES];
//    }];
}
@end
