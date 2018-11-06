//
//  GICDisplayNodeSizeUpdateProtocol.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/6.
//

#ifndef GICDisplayNodeSizeUpdateProtocol_h
#define GICDisplayNodeSizeUpdateProtocol_h

typedef void (^GICSizeChangedBlock)(CGSize size);

/**
 DisplayNode size 变更的协议的。
 适用场合类似：GICListPart
 */
@protocol GICDisplayNodeSizeUpdateProtocol <NSObject>
@property (nonatomic,copy)GICSizeChangedBlock sizeChangedBlock;
@end

#endif /* GICDisplayNodeSizeUpdateProtocol_h */
