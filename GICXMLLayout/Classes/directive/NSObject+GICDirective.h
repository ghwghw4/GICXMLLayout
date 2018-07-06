//
//  NSObject+GICDirective.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <Foundation/Foundation.h>
#import "GICDirective.h"

@interface NSObject (GICDirective)
/**
 元素的指令集合
 */
@property (nonatomic,readonly,strong)NSArray<GICDirective *> *gic_directives;

// 添加一个指令
-(void)gic_addDirective:(GICDirective *)directive;

@end
