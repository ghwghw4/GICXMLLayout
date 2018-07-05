//
//  GICDataBinding.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import "GICValueConverter.h"

typedef enum {
    GICBingdingMode_Once,//只会绑定一次，数据的改变不会再次更新
    GICBingdingMode_OneWay,// 单向绑定，每次数据源改变，都会更新绑定
    GICBingdingMode_TowWay// 双向绑定，在单向绑定的基础上，增加了反向绑定，也就是说当本身某个数据改变的时候也会影响数据源本身的数据
}GICBingdingMode;

/**
 数据绑定
 */
@interface GICDataBinding : NSObject
@property (nonatomic,assign)GICBingdingMode bingdingMode;// 默认GICBingdingMode_Once
@property (nonatomic,weak,readonly)id dataSource;
@property (nonatomic,weak)id target;
@property (nonatomic,weak)GICValueConverter *valueConverter;
@property (nonatomic,strong)NSString *expression;// 绑定的js 表达式

@property (nonatomic,assign,readonly)BOOL isInitBinding;

/**
 更新数据源

 @param dataSource <#dataSource description#>
 */
-(void)updateDataSource:(id)dataSource;

/**
 强制刷绑定的表达式的value。也即是重新计算表达式
 */
-(void)refreshExpression;
@end
