//
//  StackPanelViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/16.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "StackPanelViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation StackPanelViewModel
-(id)init{
    self=[super init];
    
    self.isHorizal = YES;
    self.isWrap = YES;
    
    _listDatas = [@[
                    @(1),@(2),@(3)
                    ] mutableCopy];
    
    
    _justifyContentItems =@[
                                    @{@"key":@"ASStackLayoutJustifyContentStart",@"value":@"0"},
                                    @{@"key":@"ASStackLayoutJustifyContentCenter",@"value":@"1"},
                                    @{@"key":@"ASStackLayoutJustifyContentEnd",@"value":@"2"},
                                    @{@"key":@"ASStackLayoutJustifyContentSpaceBetween",@"value":@"3"},
                                    @{@"key":@"ASStackLayoutJustifyContentSpaceAround",@"value":@"4"}
                                    ];
    self.selectedJustifyContent = [_justifyContentItems objectAtIndex:0];
    
    
    _alignItemsItems =@[
                                    @{@"key":@"ASStackLayoutAlignItemsStart",@"value":@"0"},
                                    @{@"key":@"ASStackLayoutAlignItemsEnd",@"value":@"1"},
                                    @{@"key":@"ASStackLayoutAlignItemsCenter",@"value":@"2"},
                                    @{@"key":@"ASStackLayoutAlignItemsStretch",@"value":@"3"},
                                @{@"key":@"ASStackLayoutAlignItemsBaselineFirst",@"value":@"4"}
                               , @{@"key":@"ASStackLayoutAlignItemsBaselineLast",@"value":@"5"}
                                    ];
    self.selectedAlignItems = [_alignItemsItems objectAtIndex:0];
    
    _alignContentItems =@[
                        @{@"key":@"ASStackLayoutAlignContentStart",@"value":@"0"},
                        @{@"key":@"ASStackLayoutAlignContentCenter",@"value":@"1"},
                        @{@"key":@"ASStackLayoutAlignContentEnd",@"value":@"2"},
                        @{@"key":@"ASStackLayoutAlignContentSpaceBetween",@"value":@"3"},
                        @{@"key":@"ASStackLayoutAlignContentSpaceAround",@"value":@"4"}
                        , @{@"key":@"ASStackLayoutAlignContentStretch",@"value":@"5"}
                        ];
    self.selectedAlignContent = [_alignContentItems objectAtIndex:0];
    
    return self;
}

-(void)setIsHorizal:(BOOL)isHorizal{
    _isHorizal = isHorizal;
}

-(void)addItem{
    [self.listDatas addObject:@(self.listDatas.count+1)];
}

-(void)deleteItem{
    [self.listDatas removeObject:self.listDatas.lastObject];
}

-(void)btnJustifyContentClicked{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    action.tag = 1;
    for(NSDictionary *dict in self.justifyContentItems){
        [action addButtonWithTitle:[dict objectForKey:@"key"]];
    }
    [action showInView:[UIApplication sharedApplication].delegate.window];
}

-(void)btnAlignItemsClicked{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    action.tag = 2;
    for(NSDictionary *dict in self.alignItemsItems){
        [action addButtonWithTitle:[dict objectForKey:@"key"]];
    }
    [action showInView:[UIApplication sharedApplication].delegate.window];
}

-(void)btnAlignContentClicked{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    action.tag = 3;
    for(NSDictionary *dict in self.alignContentItems){
        [action addButtonWithTitle:[dict objectForKey:@"key"]];
    }
    [action showInView:[UIApplication sharedApplication].delegate.window];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
        return;
    if(actionSheet.tag==1){
        NSArray *items = self.justifyContentItems;
        self.selectedJustifyContent = [items objectAtIndex:buttonIndex - 1];
    }else if (actionSheet.tag==2){
        NSArray *items = self.alignItemsItems;
        self.selectedAlignItems = [items objectAtIndex:buttonIndex - 1];
    }else if (actionSheet.tag==3){
        NSArray *items = self.alignContentItems;
        self.selectedAlignContent = [items objectAtIndex:buttonIndex - 1];
    }
   
}
@end
