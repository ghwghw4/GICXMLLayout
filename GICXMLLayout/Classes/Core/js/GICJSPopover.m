//
//  GICJSPopover.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import "GICJSPopover.h"
#import "GICPopover.h"
#import "JSValue+GICJSExtension.h"

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

+(instancetype)createPage:(NSString *)pagePath fromElement:(JSValue *)element{
    if([element isGICElement]){
        GICJSPopover * p = [GICJSPopover new];
        p->popover = [GICPopover loadPopoverPage:pagePath fromElement:[element toObject]];
        return p;
    }
    return nil;
}
@end
