//
//  PopoverSampleViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/10/30.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "PopoverSampleViewModel.h"
#import "GICXMLLayout.h"
#import "GICPopover.h"

@implementation PopoverSampleViewModel{
    GICPopover *popover;
}

-(void)showPopover:(GICEventInfo *)eventInfo{
    popover = [GICPopover loadPopoverContent:@"popover-normal" fromElement:eventInfo.target];
    [popover present:YES];
    [popover setGic_DataContext:self];
}

-(void)closePopover{
    [popover dismiss:YES];
}
@end
