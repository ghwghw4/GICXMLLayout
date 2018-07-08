//
//  IndexPageViewModel.m
//  GICXMLLayout_Example
//
//  Created by gonghaiwei on 2018/7/8.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "IndexPageViewModel.h"

@implementation IndexPageViewModel
-(id)init{
    self=[super init];
    
    self.listDatas = @[
                       @{@"name":@"支持的UI元素",@"pageName":@""},
                       @{@"name":@"数据绑定",@"pageName":@""},
                       @{@"name":@"事件",@"pageName":@""},
                       @{@"name":@"动画",@"pageName":@""},
                       ];
    return self;
}
@end
