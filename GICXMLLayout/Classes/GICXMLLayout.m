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
                [registedElements setValue:candidateClass forKey:name];
            }
        }
        free(classes);
    }
}

//+(Class)classFromElementName:(NSString *)elementName{
//    return [registedElements objectForKey:elementName];
//}

+(UIView *)createElement:(GDataXMLElement *)element{
    Class c = [registedElements objectForKey:element.name];
    if(c){
        UIView *v = [c new];
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
    UIView *p = [self createElement:rootElement];
    
    [superView addSubview:p];
    UIEdgeInsets margin = p.gic_margin;
    [p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(margin.top);
        make.left.mas_offset(margin.left);
        
        if(p.gic_Width > 0)
            make.width.mas_equalTo(p.gic_Width);
        else
            make.right.mas_offset(-margin.right);
        
        if(p.gic_Height > 0)
            make.height.mas_equalTo(p.gic_Height);
        else
            make.bottom.mas_offset(-margin.bottom);
    }];
    return p;
}
@end
