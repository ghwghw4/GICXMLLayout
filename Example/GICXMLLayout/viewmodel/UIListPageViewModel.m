//
//  UIListPageViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/9.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "UIListPageViewModel.h"
#import "GICXMLLayout.h"
#import "UtilsHelp.h"

@implementation UIListPageViewModel
-(id)init{
    self=[super init];
    
    _listDatas = @[
                   @{@"name":@"view",@"pagePath":@"ViewSample"},
//                   @{@"name":@"支持的UI元素",@"pagePath":@"UIList"},
//                   @{@"name":@"list",@"pagePath":@"ListSample"},
//                   @{@"name":@"数据绑定",@"pagePath":@""},
//                   @{@"name":@"模板",@"pagePath":@""},
//                   @{@"name":@"事件",@"pagePath":@""},
//                   @{@"name":@"动画",@"pagePath":@""},
                   ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContenxt];
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}
@end
