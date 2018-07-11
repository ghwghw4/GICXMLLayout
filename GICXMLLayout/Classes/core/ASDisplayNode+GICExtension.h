//
//  ASDisplayNode+GICExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GICDisplayNodeExtensionProperties.h"
@interface ASDisplayNode (GICExtension)<LayoutElementProtocol>
@property (nonatomic,strong,readonly)GICDisplayNodeExtensionProperties *gic_ExtensionProperties;
@end
