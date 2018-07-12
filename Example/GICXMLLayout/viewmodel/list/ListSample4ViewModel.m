//
//  ListSample4ViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/10.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "ListSample4ViewModel.h"

@implementation ListSample4ViewModel
-(id)init{
    self=[super init];
    _listDatas =[NSMutableArray array];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_queue_create("222", NULL), ^{
        for(int i=0;i<10;i++){
            //        [self.listDatas addObjectsFromArray:[self.listDatas copy]];
            [self.listDatas addObject:@{@"type":@(1),@"name":@"海伟",@"headurl":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531215187532&di=c33f0bf22b657fc6227bbb3f2fe96988&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201510%2F07%2F20151007114635_3kmeL.jpeg",@"text":@"这是在测试模板列表哦这是在测试模板列表哦这是在测试模板列表哦这是在测试模板列表哦",@"tag":@"王者荣耀",@"time":@"刚刚",@"id":@(i),@"loc":@"罗山四村"}];
            
            [self.listDatas addObject:@{@"type":@(2),@"name":@"海伟",@"headurl":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531215187532&di=c33f0bf22b657fc6227bbb3f2fe96988&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201510%2F07%2F20151007114635_3kmeL.jpeg",@"text":@"这是在测试模板列表哦",@"tag":@"王者荣耀",@"time":@"刚刚",@"id":@(i),@"loc":@"罗山四村"}];
        }
//    });
    return self;
}
@end
