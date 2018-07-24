//
//  PullRefreshBehavior.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GICXMLLayout.h"

/**
 下拉刷新的行为
 */
@interface PullRefreshBehavior : GICBehavior
@property (nonatomic,strong)GICEvent *refreshEvent;
@property (nonatomic,assign)BOOL isLoading;

@end
