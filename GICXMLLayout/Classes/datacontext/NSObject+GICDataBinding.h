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
 元素的数据绑定列表
 */
@property (nonatomic,readonly,strong)NSArray<GICDataBinding *> *gic_Bindings;


/**
 绑定的数据模型的key
 */
@property (nonatomic,strong)NSString *gic_dataModelKey;





/**
 更新数据绑定
 */
-(void)gic_updateDataBinding:(id)superDataContenxt;


/**
 添加绑定

 @param binding <#binding description#>
 */
-(void)gic_addBinding:(GICDataBinding *)binding;

//-(JSContext *)gic_getJSContext;

@end
