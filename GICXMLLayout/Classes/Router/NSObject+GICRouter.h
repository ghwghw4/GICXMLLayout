//
//  NSObject+GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/6.
//

#import <Foundation/Foundation.h>

@interface NSObject (GICRouter)
-(UINavigationController *)gic_currentNavigationController;
-(void)gic_routerGoBack;
@end
