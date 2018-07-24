//
//  BehaviorViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "BehaviorViewModel.h"

@implementation BehaviorViewModel
-(id)init{
    self=[super init];
    
    _listDatas = [@[
                    @"下拉刷新试试",@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13)
                    ] mutableCopy];
    return self;
}

-(void)onRefreshData{
    self.isRefreshing = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listDatas removeAllObjects];
        [self.listDatas addObjectsFromArray:@[
                                               @(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13)
                                               ]];
        self.isRefreshing = NO;
    });
}

-(void)onLoadMore{
    self.isLoadingMore = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listDatas addObjectsFromArray:@[
                                              @(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13)
                                              ]];
        self.isLoadingMore = NO;
    });
}

@end
