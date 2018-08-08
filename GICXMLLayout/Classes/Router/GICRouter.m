//
//  GICRouter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import "GICRouter.h"
#import "GICPage.h"
#import "GICNav.h"
#import "GICAPP.h"
#import "GICRouterLink.h"

@implementation GICRouter
+(void)regiterAllElements{
    [GICElementsCache registElement:[GICAPP class]];
    [GICElementsCache registElement:[GICPage class]];
    [GICElementsCache registElement:[GICNav class]];
    [GICElementsCache registBehaviorElement:[GICRouterLink class]];
}

+(void)loadAPPFromPath:(NSString *)path withParseCompelete:(void (^)(UIViewController *rootPage))compelte{
    [GICXMLLayout parseElementFromPathAsync:path withParentElement:nil withParseCompelete:^(id element) {
        NSAssert(element, @"parse fail");
        if(element && [element isKindOfClass:[GICAPP class]]){
            GICAPP *app = element;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].delegate.window.rootViewController = app.rootViewController;
                [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
                if(compelte)
                    compelte(app.rootViewController);
            });
        }else{
             NSAssert(false, @"error : 跟节点不是app");
            if(compelte)
                compelte(nil);
        }
    }];
}

+(void)loadPageFromPath:(NSString *)path withParseCompelete:(void (^)(GICPage *page))compelte{
    [GICXMLLayout parseElementFromPathAsync:path withParentElement:nil withParseCompelete:^(id element) {
        NSAssert(element, @"parse fail");
        if(element && [element isKindOfClass:[UIViewController class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(compelte)
                    compelte(element);
            });
        }else{
            NSAssert(false, @"error : 跟节点不是UIViewController的子类");
            if(compelte)
                compelte(nil);
        }
    }];
}
@end
