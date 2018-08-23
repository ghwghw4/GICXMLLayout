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

+(void)loadAPPFromPath:(NSString *)path{
    id element = [GICXMLLayout parseElementFromPath:path withParentElement:nil];
    NSAssert(element, @"parse fail");
    if(element && [element isKindOfClass:[GICAPP class]]){
        GICAPP *app = element;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if(window == nil){
            window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [UIApplication sharedApplication].delegate.window = window;
        }
        window.rootViewController = app.rootViewController;
        [window makeKeyAndVisible];
    }else{
        NSAssert(false, @"error : 跟节点不是app");
    }
}

+(void)loadPageFromPath:(NSString *)path withParseCompelete:(void (^)(GICPage *page))compelte{
    dispatch_async(dispatch_get_main_queue(), ^{
        id element = [GICXMLLayout parseElementFromPath:path withParentElement:nil];
        NSAssert(element, @"parse fail");
        if(element && [element isKindOfClass:[UIViewController class]]){
            if(compelte)
                compelte(element);
        }else{
            NSAssert(false, @"error : 跟节点不是UIViewController的子类");
            if(compelte)
                compelte(nil);
        }
    });
}
@end
