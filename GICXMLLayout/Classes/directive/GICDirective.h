//
//  GICDirective.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <Foundation/Foundation.h>

/**
 指令功能
 */
@interface GICDirective : GICBehavior<LayoutElementProtocol>
@property (nonatomic,weak)id target;
@end
