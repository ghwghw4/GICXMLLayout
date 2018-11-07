//
//  GICJSPopover.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import "GICJSPopover.h"
#import "GICPopover.h"
#import "JSValue+GICJSExtension.h"
#import "GICJSElementDelegate.h"

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

+(instancetype)createPage:(NSString *)pagePath fromElement:(GICJSElementDelegate *)element{
    if([element isKindOfClass:[GICJSElementDelegate class]]){
        GICJSPopover * p = [GICJSPopover new];
        p->popover = [GICPopover loadPopoverPage:pagePath fromElement:[(GICJSElementDelegate *)element element]];
        return p;
    }
    return nil;
}
@end
