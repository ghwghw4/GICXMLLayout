//
//  NSObject+GICDataBinding.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import "GICDataBinding.h"

//@class JSContext;

@interface NSObject (GICDataBinding)

/**
 绑定的数据模型的key
 */
@property (nonatomic,strong)NSString *gic_dataPathKey;

/**
 元素的数据绑定列表
 */
@property (nonatomic,readonly,strong)NSArray<GICDataBinding *> *gic_Bindings;


/**
 添加绑定

 @param binding <#binding description#>
 */
-(void)gic_addBinding:(GICDataBinding *)binding;
@end
