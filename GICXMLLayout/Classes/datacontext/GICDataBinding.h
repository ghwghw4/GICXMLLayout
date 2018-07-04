//
//  GICDataBinding.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import "GICValueConverter.h"

/**
 数据绑定
 */
@interface GICDataBinding : NSObject
@property (nonatomic,weak)id dataSource;
@property (nonatomic,weak)id target;
@property (nonatomic,strong)NSString *dataSourceValueKey;
//@property (nonatomic,strong)NSString *targetValueKey;
@property (nonatomic,weak)GICValueConverter *valueConverter;
@property (nonatomic,strong)NSString *expression;// 绑定的js 表达式

-(void)update;

@end
