//
//  GICAppDelegate.m
//  GICXMLLayout
//
//  Created by ghwghw4 on 07/02/2018.
//  Copyright (c) 2018 ghwghw4. All rights reserved.
//

#import "GICAppDelegate.h"
#import "GICXMLLayout.h"
#import "GICElementsCache.h"

#import "SwitchButton.h"
#import "GICNumberConverter.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "AutoHideKeybordBehavior.h"
#import "PullRefreshBehavior.h"
#import "PullMoreBehavior.h"
#import "GICRouter.h"
#import "GICXMLLayoutDevTools.h"
#import "WebViewElement.h"
#import "GICJSAPIManager.h"
#import "JSAPIExtension.h"


@implementation GICAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 启用默认样式
    [GICXMLLayout enableDefualtStyle:YES];
    // 注册gic类库默认所有元素
    [GICXMLLayout regiterAllElements];
    [GICRouter regiterAllElements];
    
    // 注册自定义元素
    [GICElementsCache registElement:[SwitchButton class]];
    [GICElementsCache registElement:[WebViewElement class]];
    
    //添加扩展属性
    // 对scroll-view注入扩展属性
    [GICElementsCache injectAttributes:@{ @"inset-behavior":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
        if (@available(iOS 11.0, *)) {
            // 考虑到解析的时候有可能是非UI线程解析的，这里使用GCD在主线程上访问view
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UIScrollView *)((ASDisplayNode *)target).view setContentInsetAdjustmentBehavior:[value integerValue]];
            });
        }
    }]} forElementName:@"scroll-view"];
    
    // 添加自定义行为
    [GICElementsCache registBehaviorElement:[AutoHideKeybordBehavior class]];
    [GICElementsCache registBehaviorElement:[PullRefreshBehavior class]];
    [GICElementsCache registBehaviorElement:[PullMoreBehavior class]];
    
    // 启用JS异常提示(release下请关闭)
//    [GICJSAPIManager enableJSExceptionNotify];
    // 注册JSAPI扩展
    [GICJSAPIManager addJSAPIRegisterClass:[JSAPIExtension class]];
    
    // 设置根目录.
    /**
     如果想要 hotReload的能力，请先使用命令行cd的项目的tools目录，然后输入 bash dev-tools.sh启动一个迷你http 服务器。
     启动完成后会输出三个连接地址，第一个地址用于本机访问，第二个地址用于局域网内部访问，第三个地址用于外网访问。
     */
    // NOTE:在开发的时候可以将地址修改成实际的IP地址
//    [GICXMLLayout setRootUrl:@"http://localhost:8080/sample"];
    [GICXMLLayout setRootUrl:[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"sample"]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    // NOTE：如果想要在开发的时候具备HotLoad的能力，那么取消下面的注释即可
//    [GICXMLLayoutDevTools loadAPPFromPath:@"App.xml"];
    [GICRouter loadAPPFromPath:@"App.xml"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
