//
//  GICPageRouterProtocol.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/8.
//

#ifndef GICPageRouterProtocol_h
#define GICPageRouterProtocol_h
#import "GICRouterParams.h"

@protocol GICPageRouterProtocol <NSObject>
-(void)navigationWithParams:(GICRouterParams *)params;
@optional
-(void)navigationBackWithParams:(GICRouterParams *)params;
@end


#endif /* GICPageRouterProtocol_h */
