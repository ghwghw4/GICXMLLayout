//
//  DirectiveViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/24.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "DirectiveViewModel.h"

@implementation DirectiveViewModel
-(id)init{
    self=[super init];
    _listDatas = [@[
                    @(1),@(2),@(3),@(4),@(5),@(6),@(7)
                    ] mutableCopy];
    return self;
}
@end
