//
//  IndexPageViewModel.m
//  GICXMLLayout_Example
//
//  Created by gonghaiwei on 2018/7/8.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "IndexPageViewModel.h"
#import "GICXMLLayout.h"
#import "UtilsHelp.h"
#import "GICXMLLayoutDevTools.h"

@implementation IndexPageViewModel
-(id)init{
    self=[super init];
    
    _listDatas = @[
                       @{@"name":@"布局系统",@"pagePath":@"Layout.xml"},
                       @{@"name":@"支持的UI元素",@"pagePath":@"UIList.xml"},
                       @{@"name":@"list",@"pagePath":@"ListSample.xml"},
                       @{@"name":@"数据绑定",@"pagePath":@"DataBinding.xml"},
                       @{@"name":@"模板",@"pagePath":@"Template.xml"},
                       @{@"name":@"事件",@"pagePath":@"Event.xml"},
                       @{@"name":@"动画",@"pagePath":@"Animation.xml"},
                       @{@"name":@"行为",@"pagePath":@"Behavior.xml"},
                       @{@"name":@"指令",@"pagePath":@"Directive.xml"},
                       @{@"name":@"样式",@"pagePath":@"StyleSample.xml",@"app":@(YES)},
                       @{@"name":@"模拟头条Feeds(重点是模板、布局、性能)",@"pagePath":@"app/ToutiaoRoot.xml",@"app":@(NO)},
                       ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContext];
    if([[ds objectForKey:@"app"] boolValue]){
        UIViewController *page = [GICXMLLayoutDevTools loadXMLFromUrl:[NSURL URLWithString:@"http://192.168.111.171:8080/StyleSample.xml"]];
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:page];
        [UIApplication sharedApplication].delegate.window.rootViewController =nav;
        return;
    }
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}

-(void)onSelect2{
    
}
@end
