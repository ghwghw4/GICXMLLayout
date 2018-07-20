//
//  GICXMLLayout.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICXMLLayout.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "GICXMLParserContext.h"
#import "GICTemplateRef.h"
#import "NSObject+GICTemplate.h"
#import "GICElementsCache.h"

#import "GICPage.h"
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

@implementation GICXMLLayout
+(void)regiterAllElements{
    [GICElementsCache registElement:[GICPage class]];
    
    // behavior
    [GICElementsCache registElement:[GICBehaviors class]];
    
    // 布局系统
    [GICElementsCache registElement:[GICPanel class]];
    [GICElementsCache registElement:[GICStackPanel class]];
    [GICElementsCache registElement:[GICInsetPanel class]];
    [GICElementsCache registElement:[GICDockPanel class]];
    [GICElementsCache registElement:[GICBackgroundPanel class]];
    [GICElementsCache registElement:[GICRatioPanel class]];
    
    // UI元素
    [GICElementsCache registElement:[GICGradientView class]];
    
    [GICElementsCache registElement:[GICScrollView class]];
    [GICElementsCache registElement:[GICImageView class]];
    [GICElementsCache registElement:[GICLable class]];
    [GICElementsCache registElement:[GICListView class]];
    [GICElementsCache registElement:[GICListItem class]];
    [GICElementsCache registElement:[GICInputeView class]];
    [GICElementsCache registElement:[GICInpute class]];
    
    // 指令
    [GICElementsCache registElement:[GICDirectiveFor class]];
    
    // 模板
    [GICElementsCache registElement:[GICTemplate class]];
    [GICElementsCache registElement:[GICTemplateRef class]];
    [GICElementsCache registElement:[GICTemplates class]];
    
    //动画
    [GICElementsCache registElement:[GICAnimations class]];
    [GICElementsCache registElement:[GICAttributeAnimation class]];
    
    
    //        int numberOfClasses = objc_getClassList(NULL, 0);
    //        Class *classes = (Class *)malloc(sizeof(Class) * numberOfClasses);
    //        numberOfClasses = objc_getClassList(classes, numberOfClasses);
    //        // 取出所有实现了gic_elementName方法的类
    //        for (int i = 0; i < numberOfClasses; i++) {
    //            Class candidateClass = classes[i];
    //            if(class_getClassMethod(candidateClass, @selector(gic_elementName))){
    //                NSString *name = [candidateClass performSelector:@selector(gic_elementName)];
    //                if(name && [name length]>0){
    //                    [registedElements setValue:candidateClass forKey:name];
    //                }
    //            }
    //        }
    //        free(classes);
}

+(NSObject *)createElement:(GDataXMLElement *)element withSuperElement:(id)superElement{
    NSString *elementName = element.name;
    Class c = [GICElementsCache classForElementName:elementName];
    if(c){
        NSObject *v = [c new];
        [v gic_beginParseElement:element withSuperElement:superElement];
        return v;
    }
    return nil;
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
        UIView *p = (UIView *)[self createElement:rootElement withSuperElement:superView];
        [superView addSubview:p];
        [GICXMLParserContext parseCompelete];
        dispatch_async(dispatch_get_main_queue(), ^{
            compelte(p);
        });
    });
}

+(void)parseLayoutPage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte{
    NSError *error = nil;
    //    ASDisplayNode.shouldShowRangeDebugOverlay = YES;
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
            compelte(nil);
        }
    });
}
@end
