//
//  GICNavbarButtons.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICNavbarButtons.h"

@implementation GICNavbarButtons

-(id)init{
    self = [super init];
    _buttons = [NSMutableArray array];
    return self;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        [_buttons addObject:subElement];
    }else{
        [super gic_addSubElement:subElement];
    }
}
@end
