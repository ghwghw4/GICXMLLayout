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

+(void)loadAPP:(NSData *)xmlData{
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        return;
    }
    // 取根节点
    dispatch_async(dispatch_get_main_queue(), ^{
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        if([rootElement.name isEqualToString:[GICAPP gic_elementName]]){
            [GICXMLParserContext resetInstance:xmlDocument];
            GICAPP *app = (GICAPP *)[NSObject gic_createElement:rootElement withSuperElement:nil];
            [GICXMLParserContext parseCompelete];
            [UIApplication sharedApplication].delegate.window.rootViewController = app.rootViewController;
            [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        }else{
            NSAssert(false, @"error : 跟节点不是app");
        }
    });
}

+(void)parsePage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte{
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
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
            compelte(vc);
        }else{
            NSAssert(false, @"error : 跟节点不是page");
            compelte(nil);
        }
    });
}
@end
