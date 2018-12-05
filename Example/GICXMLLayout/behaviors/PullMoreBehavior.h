//
//  PullMoreBehavior.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/24.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GICXMLLayout/GICXMLLayout.h>

/**
 下拉更多
 */
@interface PullMoreBehavior : GICBehavior
@property (nonatomic,strong)GICEvent *refreshEvent;
@property (nonatomic,assign)BOOL isLoading;
@end
