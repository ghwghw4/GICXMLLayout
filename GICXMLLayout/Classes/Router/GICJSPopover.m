//
//  GICJSPopover.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import "GICJSPopover.h"
#import "JSValue+GICJSExtension.h"
#import "GICJSElementDelegate.h"
#import "GICJSDocument.h"

@implementation GICJSPopover{
    UIViewController *contentViewControler;
    JSManagedValue *managedValueOndismiss;
}

-(void)setOndismiss:(JSValue *)ondismiss{
    managedValueOndismiss = [JSManagedValue managedValueWithValue:ondismiss];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedValueOndismiss withOwner:self];
}

-(JSValue *)ondismiss { return  managedValueOndismiss.value; }

-(void)present:(BOOL)animation{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    //    if(contentNode){
    //        contentNode.frame = window.bounds;
    //        [self.view addSubview:contentNode.view];
    //    }else
    if (contentViewControler){
        [self.view addSubview:contentViewControler.view];
    }
    // 将presentViewController  设置为透明。否则系统会默认给一个白色背景
    window.rootViewController.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [window.rootViewController presentViewController:self animated:animation completion:nil];
}

// 隐藏弹框
-(void)dismiss:(BOOL)animation params:(JSValue *)params{
    [self dismissViewControllerAnimated:animation completion:nil];
    if(managedValueOndismiss){
        [managedValueOndismiss.value callWithArguments:@[params]];
    }
}

+(instancetype)create:(NSString *)pagePath{
    GICJSPopover *popover = [[GICJSPopover alloc] init];
    popover.gic_ExtensionProperties.superElement = [GICJSDocument rootElement];
    id obj = [GICXMLLayout parseElementFromPath:pagePath withParentElement:popover];
    NSAssert(obj, @"parse fail，请检查路径是否正确，XML格式是否正确");
    if(obj && [obj isKindOfClass:[UIViewController class]]){
        popover->contentViewControler = (UIViewController *)obj;
    }else{
        NSAssert(false, @"Popover 内从必须是UIViewController 或者UIViewController 的子类");
    }
    return popover;
}
@end
