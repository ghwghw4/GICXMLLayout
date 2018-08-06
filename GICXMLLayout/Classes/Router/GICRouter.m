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
    [GICXMLLayout parseElementFromPath:path withParentElement:nil withParseCompelete:^(id element) {
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

//+(void)loadAPP:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *rootPage))compelte{
//    NSError *error = nil;
//    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
//    if (error) {
//        NSLog(@"error : %@", error);
//        return;
//    }
//    // 取根节点
//    dispatch_async(dispatch_get_main_queue(), ^{
//        GDataXMLElement *rootElement = [xmlDocument rootElement];
//        if([rootElement.name isEqualToString:[GICAPP gic_elementName]]){
//            [GICXMLParserContext resetInstance:xmlDocument];
//            GICAPP *app = (GICAPP *)[NSObject gic_createElement:rootElement withSuperElement:nil];
//            [GICXMLParserContext parseCompelete];
//            [UIApplication sharedApplication].delegate.window.rootViewController = app.rootViewController;
//            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
//            if(compelte)
//                compelte(app.rootViewController);
//        }else{
//            NSAssert(false, @"error : 跟节点不是app");
//            if(compelte)
//                compelte(nil);
//        }
//    });
//}

//+(void)parsePage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte{
//    NSError *error = nil;
//    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
//    if (error) {
//        NSLog(@"error : %@", error);
//        if(compelte)
//            compelte(nil);
//        return;
//    }
//
//    // 取根节点
//    dispatch_async(dispatch_get_main_queue(), ^{
//        GDataXMLElement *rootElement = [xmlDocument rootElement];
//        if([rootElement.name isEqualToString:@"page"]){
//            [GICXMLParserContext resetInstance:xmlDocument];
//            GICPage *vc =[[GICPage alloc] initWithXmlElement:rootElement];
//            [GICXMLParserContext parseCompelete];
//            if(compelte)
//                compelte(vc);
//        }else{
//            NSAssert(false, @"error : 跟节点不是page");
//            if(compelte)
//                compelte(nil);
//        }
//    });
//}

+(void)loadPageFromPath:(NSString *)path withParseCompelete:(void (^)(UIViewController *page))compelte{
    NSData *xmlData = [GICXMLLayout loadXmlDataFromPath:path];
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        if(compelte)
            compelte(nil);
        return;
    }
    
    // 取根节点
    dispatch_async(dispatch_get_main_queue(), ^{
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        if([rootElement.name isEqualToString:@"page"]){
            [GICXMLParserContext resetInstance:xmlDocument];
            GICPage *vc =[[GICPage alloc] initWithXmlElement:rootElement];
            [GICXMLParserContext parseCompelete];
            if(compelte)
                compelte(vc);
        }else{
            NSAssert(false, @"error : 跟节点不是page");
            if(compelte)
                compelte(nil);
        }
    });
}
//
//+(UINavigationController *)getCurrentNavigationControllerFromViewModel:(id)viewModel{
//    id superEl=[viewModel gic_ExtensionProperties].superElement;
//    do {
//        if([superEl isKindOfClass:[UINavigationController class]]){
//            return superEl;
//        }else{
//            superEl = [superEl gic_getSuperElement];
//        }
//    } while (superEl);
//    return nil;
//}
@end
