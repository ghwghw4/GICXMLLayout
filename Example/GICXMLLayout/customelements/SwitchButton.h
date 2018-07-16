//
//  SwitchButton.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/16.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GICXMLLayout.h"

@interface SwitchButton : ASDisplayNode<GICLayoutElementProtocol>
@property (readonly) UISwitch *view;
@end
