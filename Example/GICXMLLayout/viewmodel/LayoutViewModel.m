//
//  LayoutViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/16.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "LayoutViewModel.h"
#import "GICXMLLayout.h"
#import "UtilsHelp.h"

@implementation LayoutViewModel
-(id)init{
    self=[super init];
    _listDatas = @[
                   @{@"name":@"panel(绝对布局)",@"pagePath":@"Panel"},
                   @{@"name":@"stack-panel(flex 布局)",@"pagePath":@"StackPanel"},
                   @{@"name":@"stack-panel 动态演示",@"pagePath":@"StackPanel2"},
                   @{@"name":@"inset-panel(padding 布局)",@"pagePath":@"InsetPanel"},
                   @{@"name":@"dock-panel(停靠 布局)",@"pagePath":@"DockPanel"},
                   @{@"name":@"background-panel(背景 布局)",@"pagePath":@"BackgroundPanel"},
                   @{@"name":@"ratio-panel(比例布局)",@"pagePath":@"RatioPanel"},
                   ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContext];
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}
@end
