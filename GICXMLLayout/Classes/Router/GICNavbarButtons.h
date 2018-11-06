//
//  GICNavbarButtons.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "GICStackPanel.h"
#import "GICDisplayNodeSizeUpdateProtocol.h"

@interface GICNavbarButtons : GICStackPanel<GICDisplayNodeSizeUpdateProtocol>
@property (nonatomic,copy)GICSizeChangedBlock sizeChangedBlock;
@end
