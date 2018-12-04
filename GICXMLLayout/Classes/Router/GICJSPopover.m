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
#import "GICJSCore.h"

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
    // 将presentViewController  设置为透明。否则系统会默认给一个白色背景
    window.rootViewController.definesPresentationContext = YES;
    if (contentViewControler){
        contentViewControler.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [window.rootViewController presentViewController:contentViewControler animated:animation completion:nil];
    }
    [[contentViewControler rac_willDeallocSignal] subscribeCompleted:^{
        NSLog(@"viewcontrol dealloc");
    }];
}

// 隐藏弹框
-(void)dismiss:(BOOL)animation params:(JSValue *)params{
    [contentViewControler dismissViewControllerAnimated:animation completion:nil];
    if(managedValueOndismiss){
        [managedValueOndismiss.value callWithArguments:@[params]];
    }
    self->contentViewControler = nil;
}

+(instancetype)create:(NSString *)pagePath{
    GICJSPopover *popover = [[GICJSPopover alloc] init];
    id obj = [GICXMLLayout parseElementFromPath:pagePath withParentElement:nil];
    // 共享JSContext
    if([obj isKindOfClass:[UINavigationController class]]){
        [GICJSCore shareJSContext:[GICJSDocument rootElementFromJsContext:nil] to:[(UINavigationController *)obj visibleViewController]];
    }else{
        [GICJSCore shareJSContext:[GICJSDocument rootElementFromJsContext:nil] to:obj];
    }
    NSAssert(obj, @"parse fail，请检查路径是否正确，XML格式是否正确");
    if(obj && [obj isKindOfClass:[UIViewController class]]){
        popover->contentViewControler = (UIViewController *)obj;
    }else{
        NSAssert(false, @"Popover 内从必须是UIViewController 或者UIViewController 的子类");
    }
    return popover;
}

-(void)dealloc{
    NSLog(@"dealoc");
}
@end
