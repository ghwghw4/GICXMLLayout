//
//  BehaviorViewModel.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BehaviorViewModel : NSObject
@property (nonatomic,strong,readonly)NSMutableArray *listDatas;
@property (nonatomic,assign)BOOL isRefreshing;
@property (nonatomic,assign)BOOL isLoadingMore;
@end
