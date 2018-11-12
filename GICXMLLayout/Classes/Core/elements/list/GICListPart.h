//
//  GICListPart.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/5.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GICDisplayNodeSizeUpdateProtocol.h"
#import "GICStackPanel.h"

@interface GICListPart : ASCellNode<GICDisplayNodeSizeUpdateProtocol>
@property (nonatomic,copy)GICSizeChangedBlock sizeChangedBlock;
@end
