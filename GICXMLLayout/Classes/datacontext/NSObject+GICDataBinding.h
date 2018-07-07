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
 添加绑定

 @param binding <#binding description#>
 */
-(void)gic_addBinding:(GICDataBinding *)binding;

//-(JSContext *)gic_getJSContext;

@end
