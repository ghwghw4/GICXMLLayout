//
//  DataBindingViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "DataBindingViewModel.h"
#import "GICXMLLayout.h"
@implementation DataBindingUserInfo
-(id)init{
    self = [super init];
    _name = @"海伟1";
    _age = 22;
    return self;
}
@end

@implementation DataBindingViewModel

-(id)init{
    self = [super init];
    
    __weak DataBindingViewModel *wself= self;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        NSDate *d = [NSDate date];
        wself.timeStamp = [d timeIntervalSince1970];
    });
    dispatch_resume(timer);
    return self;
}

-(void)clickToBinding:(GICEventInfo *)eventInfo{
    NSObject *el = [[eventInfo.target gic_getSuperElement] gic_findSubElementFromName:@"testBingding1"];
    el.gic_DataContenxt = [DataBindingUserInfo new];
}
@end
