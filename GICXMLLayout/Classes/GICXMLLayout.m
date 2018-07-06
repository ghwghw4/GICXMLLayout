//
//  GICXMLLayout.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICXMLLayout.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIView+LayoutView.h"
#import <Masonry/Masonry.h>
#import "UIView+GICExtension.h"

@implementation GICXMLLayout
static NSMutableDictionary *registedElements = nil;
+(void)regiterAllElements{
    if (registedElements == nil) {
        registedElements = [NSMutableDictionary dictionary];
        int numberOfClasses = objc_getClassList(NULL, 0);
        Class *classes = (Class *)malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);
        // 取出所有实现了gic_elementName方法的类
        for (int i = 0; i < numberOfClasses; i++) {
            Class candidateClass = classes[i];
            if(class_getClassMethod(candidateClass, @selector(gic_elementName))){
                NSString *name = [candidateClass performSelector:@selector(gic_elementName)];
                if(name && [name length]>0){
                    [registedElements setValue:candidateClass forKey:name];
                }
            }
        }
        free(classes);
    }
}

+(NSObject *)createElement:(GDataXMLElement *)element{
    Class c = [registedElements objectForKey:element.name];
    if(c){
        NSObject *v = [c new];
        [v parseElement:element];
        return v;
    }
    return nil;
}

+(UIView *)parseLayout:(NSData *)xmlData toView:(UIView *)superView{
    NSError *error = nil;
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        return nil;
    }
    // 取根节点
    GDataXMLElement *rootElement = [xmlDocument rootElement];
    UIView *p = (UIView *)[self createElement:rootElement];
    [superView addSubview:p];
    [superView gic_LayoutSubView:p];
    return p;
}
@end
