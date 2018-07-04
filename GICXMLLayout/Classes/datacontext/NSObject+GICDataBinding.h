//
//  NSObject+GICDataBinding.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import "GICDataBinding.h"

@interface UIView (GICDataBinding)

/**
 元素的数据绑定列表
 */
@property (nonatomic,readonly,strong)NSMutableArray<GICDataBinding *> *gic_Bindings;


/**
 绑定的数据模型的key
 */
@property (nonatomic,strong)NSString *gic_dataModelKey;

/**
 更新数据绑定
 */
-(void)gic_updateDataBinding:(id)dataContenxt;
@end
