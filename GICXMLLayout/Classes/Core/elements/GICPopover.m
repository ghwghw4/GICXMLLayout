//
//  GICPopover.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import "GICPopover.h"
#import "NSObject+GICTemplate.h"
#import "GICTemplateRef.h"

@implementation GICPopover{
    ASDisplayNode *contentNode;
    
    UIViewController *contentViewControler;
}

// 显示弹框
-(void)present:(BOOL)animation{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    

    
    if(contentNode){
        contentNode.frame = window.bounds;
        [self.view addSubview:contentNode.view];
    }else if (contentViewControler){
        [self.view addSubview:contentViewControler.view];
    }
    
    
   
    // 将presentViewController  设置为透明。否则系统会默认给一个白色背景
    window.rootViewController.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [window.rootViewController presentViewController:self animated:animation completion:nil];
}

-(void)dismiss:(BOOL)animation{
    [self dismissViewControllerAnimated:animation completion:nil];
}

+(GICPopover *)loadPopoverContent:(NSString *)templateName fromElement:(id)element{
    GICTemplate *template = [element gic_getTemplateFromName:templateName];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:template.xmlDocString options:0 error:nil];
    GICPopover *popover = [[GICPopover alloc] init];
    NSObject * obj = [NSObject gic_createElement:[xmlDoc rootElement] withSuperElement:popover];
    if([obj isKindOfClass:[ASDisplayNode class]]){
        popover->contentNode = (ASDisplayNode *)obj;
    }else if ([obj isKindOfClass:[UIViewController class]]){
        popover->contentViewControler = (UIViewController *)obj;
    }else{
        NSAssert(false, @"模板内容必须是UI元素");
    }
    popover.gic_ExtensionProperties.superElement = element;
    return popover;
}
@end
