//
//  GICJSPopover.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import "GICJSPopover.h"
#import "GICPopover.h"
#import "GICJSElementValue.h"

@implementation GICJSPopover{
    GICPopover *popover;
}

-(void)present:(BOOL)animation{
    [popover present:animation];
}

// 隐藏弹框
-(void)dismiss:(BOOL)animation{
    [popover dismiss:animation];
}

+(instancetype)create:(NSString *)templateName fromElement:(id)element{
    if([element isKindOfClass:[GICJSElementValue class]]){
        GICJSPopover * p = [GICJSPopover new];
        p->popover = [GICPopover loadPopoverContent:templateName fromElement:[(GICJSElementValue *)element element]];
        return p;
    }
    return nil;
}
@end
