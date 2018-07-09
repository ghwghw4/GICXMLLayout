//
//  IndexPageViewModel.m
//  GICXMLLayout_Example
//
//  Created by gonghaiwei on 2018/7/8.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "IndexPageViewModel.h"
#import "GICXMLLayout.h"

@implementation IndexPageViewModel
-(id)init{
    self=[super init];
    
    self.listDatas = @[
                       @{@"name":@"布局系统",@"pageName":@""},
                       @{@"name":@"支持的UI元素",@"pageName":@""},
                       @{@"name":@"数据绑定",@"pageName":@""},
                       @{@"name":@"模板",@"pageName":@""},
                       @{@"name":@"事件",@"pageName":@""},
                       @{@"name":@"动画",@"pageName":@""},
                       ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    id ds = [eventInfo.target gic_DataContenxt];
    NSLog(@"%@",ds);
}
@end
