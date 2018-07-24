//
//  GICBehavior.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/12.
//

#import "GICBehavior.h"

@implementation GICBehavior
-(void)attachTo:(id)target{
    _target = target;
    self.gic_ExtensionProperties.superElement = target;
}

-(void)unattach{
    
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(void)dealloc{
    [self unattach];
}
@end
