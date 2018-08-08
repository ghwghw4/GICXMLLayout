//
//  NSObject+GICRouter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/6.
//

#import "NSObject+GICRouter.h"

@implementation NSObject (GICRouter)
-(id<GICRouterProtocol>)gic_Router{
    id superEl=[self gic_ExtensionProperties].superElement;
    do {
        if([superEl conformsToProtocol:@protocol(GICRouterProtocol)]){
            return superEl;
        }else{
            superEl = [superEl gic_getSuperElement];
        }
    } while (superEl);
    return nil;
}

//-(GICPage *)gic_CurrentPage{
//    id superEl=[self gic_ExtensionProperties].superElement;
//    do {
//        if([superEl isKindOfClass:[GICPage class]]){
//            return superEl;
//        }else{
//            superEl = [superEl gic_getSuperElement];
//        }
//    } while (superEl);
//    return nil;
//
//}
@end
