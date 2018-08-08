//
//  NSObject+GICRouter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/6.
//

#import <Foundation/Foundation.h>
#import "GICRouterProtocol.h"
//#import "GICPage.h"
@interface NSObject (GICRouter)
-(id<GICRouterProtocol>)gic_Router;

//-(GICPage *)gic_CurrentPage;
@end
