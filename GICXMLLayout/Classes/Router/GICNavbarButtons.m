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

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        [_buttons addObject:subElement];
        return subElement;
    }else{
        return [super gic_addSubElement:subElement];
    }
}
@end
