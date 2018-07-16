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
                   @{@"name":@"inset-panel(padding 布局)",@"pagePath":@"Layout"},
                   @{@"name":@"dock-panel(停靠 布局)",@"pagePath":@"Layout"},
                   @{@"name":@"background-panel(背景 布局)",@"pagePath":@"Layout"},
                   ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContenxt];
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}
@end
