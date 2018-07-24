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

@implementation IndexPageViewModel
-(id)init{
    self=[super init];
    
    _listDatas = @[
                       @{@"name":@"布局系统",@"pagePath":@"Layout"},
                       @{@"name":@"支持的UI元素",@"pagePath":@"UIList"},
                       @{@"name":@"list",@"pagePath":@"ListSample"},
                       @{@"name":@"数据绑定",@"pagePath":@"DataBinding"},
                       @{@"name":@"模板",@"pagePath":@"Template"},
                       @{@"name":@"事件",@"pagePath":@"Event"},
                       @{@"name":@"动画",@"pagePath":@"Animation"},
                       @{@"name":@"行为",@"pagePath":@"Behavior"},
                       @{@"name":@"指令",@"pagePath":@"Directive"},
                       ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContenxt];
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}
@end
