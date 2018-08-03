//
//  GICXMLLayout.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICXMLLayout.h"
#import "GICXMLLayoutPrivate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "GICXMLParserContext.h"
#import "GICTemplateRef.h"
#import "NSObject+GICTemplate.h"
#import "GICElementsCache.h"
#import "GICPanel.h"
#import "GICStackPanel.h"
#import "GICInsetPanel.h"
#import "GICDockPanel.h"
#import "GICScrollView.h"
#import "GICGradientView.h"
#import "GICImageView.h"
#import "GICLable.h"
#import "GICListView.h"
#import "GICListItem.h"
#import "GICDirectiveFor.h"
#import "GICTemplate.h"
#import "GICTemplateRef.h"
#import "GICTemplates.h"
#import "GICAnimations.h"
#import "GICBackgroundPanel.h"
#import "GICBehaviors.h"
#import "GICAnimations.h"
#import "GICInpute.h"
#import "GICInputeView.h"
#import "GICAttributeAnimation.h"
#import "GICRatioPanel.h"
#import "GICTransformAnimations.h"
#import "GICDirectiveIf.h"
#import "GICStyle.h"

@implementation GICXMLLayout
+(void)regiterAllElements{
    [self regiterUIElements];
    [self regiterCoreElements];
}

+(void)regiterCoreElements{
    // behavior
    [GICElementsCache registElement:[GICBehaviors class]];
    
    // 布局系统
    [GICElementsCache registElement:[GICPanel class]];
    [GICElementsCache registElement:[GICStackPanel class]];
    [GICElementsCache registElement:[GICInsetPanel class]];
    [GICElementsCache registElement:[GICDockPanel class]];
    [GICElementsCache registElement:[GICBackgroundPanel class]];
    [GICElementsCache registElement:[GICRatioPanel class]];
    
    // 指令
    [GICElementsCache registElement:[GICDirectiveFor class]];
    [GICElementsCache registElement:[GICDirectiveIf class]];
    
    // 模板
    [GICElementsCache registElement:[GICTemplateRef class]];
    [GICElementsCache registElement:[GICTemplates class]];
    
    //动画
    [GICElementsCache registElement:[GICAnimations class]];
    [GICElementsCache registElement:[GICAttributeAnimation class]];
    [GICElementsCache registElement:[GICTransformAnimations class]];
    
    //样式
    [GICElementsCache registElement:[GICStyle class]];
}

+(void)regiterUIElements{
//    [GICElementsCache registElement:[GICPage class]];
    // UI元素
    [GICElementsCache registElement:[GICGradientView class]];
    
    [GICElementsCache registElement:[GICScrollView class]];
    [GICElementsCache registElement:[GICImageView class]];
    [GICElementsCache registElement:[GICLable class]];
    [GICElementsCache registElement:[GICListView class]];
    [GICElementsCache registElement:[GICListItem class]];
    [GICElementsCache registElement:[GICInputeView class]];
    [GICElementsCache registElement:[GICInpute class]];
}

static BOOL _enableDefualtStyle;
+(void)enableDefualtStyle:(BOOL)enable{
    _enableDefualtStyle = enable;
}

+(BOOL)enableDefualtStyle{
    return _enableDefualtStyle;
}

static NSString *_roolUrl;
+(void)setRootUrl:(NSString *)rootUrl{
    _roolUrl = rootUrl;
}

+(NSString *)rootUrl{
    return _roolUrl;
}


+(void)parseElementFromUrl:(NSURL *)url withParentElement:(id)parentElement withParseCompelete:(void (^)(id element))compelte{
    NSData *xmlData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        compelte(nil);
        return;
    }
    dispatch_async(dispatch_queue_create("parse xml element", nil), ^{
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        [GICXMLParserContext resetInstance:xmlDocument];
        id e = [NSObject gic_createElement:rootElement withSuperElement:parentElement];
        [GICXMLParserContext parseCompelete];
        compelte(e);
    });
}

+(void)parseElementFromPath:(NSString *)path withParentElement:(id)parentElement withParseCompelete:(void (^)(id element))compelte{
    NSAssert(_roolUrl, @"请先设置roolUrl");
    [self parseElementFromUrl:[NSURL URLWithString:[_roolUrl stringByAppendingPathComponent:path]] withParentElement:parentElement withParseCompelete:compelte];
}

+(void)parseLayoutView:(NSData *)xmlData toView:(UIView *)superView withParseCompelete:(void (^)(UIView *view))compelte{
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        compelte(nil);
        return;
    }
    // 取根节点
    dispatch_async(dispatch_queue_create("parse xml view", nil), ^{
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        [GICXMLParserContext resetInstance:xmlDocument];
        ASDisplayNode *p = (ASDisplayNode *)[NSObject gic_createElement:rootElement withSuperElement:superView];
        [GICXMLParserContext parseCompelete];
        dispatch_async(dispatch_get_main_queue(), ^{
            p.frame = superView.bounds;
            [superView addSubview:p.view];
            compelte(p.view);
        });
    });
}

+(void)parseLayoutPage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte{
//    NSError *error = nil;
//    //    ASDisplayNode.shouldShowRangeDebugOverlay = YES;
//    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
//    if (error) {
//        NSLog(@"error : %@", error);
//        compelte(nil);
//        return;
//    }
//    // 取根节点
//    dispatch_async(dispatch_get_main_queue(), ^{
//        GDataXMLElement *rootElement = [xmlDocument rootElement];
//        if([rootElement.name isEqualToString:@"page"]){
//            [GICXMLParserContext resetInstance:xmlDocument];
//            GICPage *vc =[[GICPage alloc] initWithXmlElement:rootElement];
//            [GICXMLParserContext parseCompelete];
//            compelte(vc);
//        }else{
//            compelte(nil);
//        }
//    });
}
@end
