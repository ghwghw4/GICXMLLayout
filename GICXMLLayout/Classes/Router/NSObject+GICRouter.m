//
//  NSObject+GICRouter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/6.
//

#import "NSObject+GICRouter.h"

@implementation NSObject (GICRouter)
-(UINavigationController *)gic_currentNavigationController{
    id superEl=[self gic_ExtensionProperties].superElement;
    do {
        if([superEl isKindOfClass:[UINavigationController class]]){
            return superEl;
        }else{
            superEl = [superEl gic_getSuperElement];
        }
    } while (superEl);
    return nil;
}

-(void)gic_routerGoBack{
    [[self gic_currentNavigationController] popViewControllerAnimated:YES];
}
@end
