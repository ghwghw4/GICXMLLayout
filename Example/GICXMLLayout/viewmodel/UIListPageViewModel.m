//
//  UIListPageViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/9.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "UIListPageViewModel.h"

@implementation UIListPageViewModel
-(id)init{
    self=[super init];
    
    return self;
}

-(void)onButtonClicked{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"title" message:@"你点击了button" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
@end
