//
//  ToutiaoViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/29.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "ToutiaoViewModel.h"

@implementation ToutiaoViewModel
-(id)init{
    self=[super init];
//    _listDatas = [@[@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7"] mutableCopy];
    _listDatas = [NSMutableArray array];
    [self onRefreshData];
    return self;
}

-(void)onRefreshData{
    if(self.isRefreshing)
        return;
    self.isRefreshing = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listDatas removeAllObjects];
        [self.listDatas addObjectsFromArray:@[@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7",@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7",@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7"
                                              ]];
        self.isRefreshing = NO;
    });
}

-(void)onLoadMore{
    self.isLoadingMore = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listDatas addObjectsFromArray:@[@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7",@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7",@"t1",@"t2",@"t3",@"t4",@"t5",@"t6",@"t7"
                                              ]];
        self.isLoadingMore = NO;
    });
}
@end
