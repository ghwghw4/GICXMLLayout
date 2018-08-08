//
//  UIListPageViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/9.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "UIListPageViewModel.h"
#import "GICXMLLayout.h"
#import "UtilsHelp.h"

@implementation UIListPageViewModel
-(id)init{
    self=[super init];
    
    _listDatas = @[
                   @{@"name":@"view",@"pagePath":@"ViewSample"},
                   @{@"name":@"lable",@"pagePath":@"Lable"},
                   @{@"name":@"input",@"pagePath":@"Inpute"},
                   ];
    return self;
}

-(void)onSelect:(GICEventInfo *)eventInfo{
    NSDictionary *ds = [eventInfo.target gic_DataContext];
    [UtilsHelp navigateToGICPage:[ds objectForKey:@"pagePath"]];
}
@end
