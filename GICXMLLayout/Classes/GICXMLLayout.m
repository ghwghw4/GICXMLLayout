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


#import "GICPage.h"
#import "GICView.h"
#import "GICPanel.h"
#import "GICStackPanel.h"
#import "GICInsetPanel.h"
#import "GICDockPanel.h"
#import "GICScrollView.h"
#import "GICImageView.h"
#import "GICLable.h"
#import "GICListView.h"
#import "GICListItem.h"
#import "GICDirectiveFor.h"
#import "GICTemplate.h"
#import "GICTemplateRef.h"
#import "GICTemplates.h"

@implementation GICXMLLayout
static NSMutableDictionary<NSString *,Class> *registedElements = nil;
+(void)regiterAllElements{
    if (registedElements == nil) {
        
        registedElements = [NSMutableDictionary dictionary];
        [self registElement:[GICPage class]];
        
        // 布局系统
        [self registElement:[GICPanel class]];
        [self registElement:[GICStackPanel class]];
        [self registElement:[GICInsetPanel class]];
        [self registElement:[GICDockPanel class]];

        // UI元素
        [self registElement:[GICView class]];
        [self registElement:[GICScrollView class]];
        [self registElement:[GICImageView class]];
        [self registElement:[GICLable class]];
        [self registElement:[GICListView class]];
        [self registElement:[GICListItem class]];
        
        // 指令
        [self registElement:[GICDirectiveFor class]];
        
        // 模板
        [self registElement:[GICTemplate class]];
        [self registElement:[GICTemplateRef class]];
        [self registElement:[GICTemplates class]];
        
       
        
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
}

+(void)registElement:(Class)elementClass{
    if(class_getClassMethod(elementClass, @selector(gic_elementName))){
        NSString *name = [elementClass performSelector:@selector(gic_elementName)];
        if(name && [name length]>0){
            [registedElements setValue:elementClass forKey:name];
        }
    }
}

+(NSObject *)createElement:(GDataXMLElement *)element{
    Class c = [registedElements objectForKey:element.name];
    if(c){
        NSObject *v = [c new];
        [v gic_parseElement:element];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        [GICXMLParserContext resetInstance:xmlDocument];
        UIView *p = (UIView *)[self createElement:rootElement];
        [superView addSubview:p];
//        [superView gic_LayoutSubView:p];
        [GICXMLParserContext parseCompelete];
        compelte(p);
    });
}

+(void)parseLayoutPage:(NSData *)xmlData withParseCompelete:(void (^)(UIViewController *page))compelte{
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        compelte(nil);
        return;
    }
    // 取根节点
//    dispatch_async(dispatch_queue_create("1111", nil), ^{
        GDataXMLElement *rootElement = [xmlDocument rootElement];
        if([rootElement.name isEqualToString:@"page"]){
            [GICXMLParserContext resetInstance:xmlDocument];
            GICPage *vc =[[GICPage alloc] initWithXmlElement:rootElement];
//            OverviewViewController *vc =[[OverviewViewController alloc] initWithXmlElement:rootElement];
            [GICXMLParserContext parseCompelete];
//            dispatch_async(dispatch_get_main_queue(), ^{
                compelte(vc);
//            });
        }else{
            compelte(nil);
        }
//    });
}
@end
