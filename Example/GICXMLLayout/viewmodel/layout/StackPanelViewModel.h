//
//  StackPanelViewModel.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/16.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackPanelViewModel : NSObject<UIActionSheetDelegate>
@property (nonatomic,assign)BOOL isHorizal;
@property (nonatomic,assign)BOOL isWrap;
@property (nonatomic,strong,readonly)NSMutableArray *listDatas;

@property (nonatomic,readonly)NSArray *justifyContentItems;
@property (nonatomic,strong)NSDictionary *selectedJustifyContent;


@property (nonatomic,readonly)NSArray *alignItemsItems;
@property (nonatomic,strong)NSDictionary *selectedAlignItems;

@property (nonatomic,readonly)NSArray *alignContentItems;
@property (nonatomic,strong)NSDictionary *selectedAlignContent;
@end
