//
//  ListSamplePageViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/9.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "ListSamplePageViewModel.h"
#import "UtilsHelp.h"

@implementation ListSamplePageViewModel
-(void)onSelect1{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"title" message:@"懒人！直接查看ListSample.xml文件吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

-(void)onSelect2{
    [UtilsHelp navigateToGICPage:@"ListSample2"];
}

-(void)onSelect3{
    [UtilsHelp navigateToGICPage:@"ListSample3"];
}
@end
