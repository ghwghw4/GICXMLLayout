//
//  ListSample3ViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/10.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "ListSample3ViewModel.h"

@implementation ListSample3ViewModel
-(id)init{
    self=[super init];
    
    _listDatas = [@[
                   @(1),@(2),@(3),@(4),
                   ] mutableCopy];
    return self;
}

-(void)addItem{
    [self.listDatas addObject:@(self.listDatas.count+1)];
}

-(void)deleteItem{
    [self.listDatas removeObject:self.listDatas.lastObject];
}
@end
