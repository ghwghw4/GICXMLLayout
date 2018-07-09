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
                       @{@"name":@"布局系统",@"pagePath":@"LayoutSample"},
                       @{@"name":@"支持的UI元素",@"pagePath":@"UIList"},
                       @{@"name":@"list",@"pagePath":@"ListSample"},
                       @{@"name":@"数据绑定",@"pagePath":@""},
                       @{@"name":@"模板",@"pagePath":@""},
                       @{@"name":@"事件",@"pagePath":@""},
                       @{@"name":@"动画",@"pagePath":@""},
                       ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContenxt];
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}
@end
