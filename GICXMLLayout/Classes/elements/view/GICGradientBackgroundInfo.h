//
//  GICGradientBackgroundInfo.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/13.
//

#import <Foundation/Foundation.h>

/**
 渐变色颜色信息
 */
@interface GICGradientBackgroundInfo : NSObject
@property (nonatomic,strong)NSArray *colors;
@property (nonatomic,strong)NSArray *locations;
@property (nonatomic,assign)CGPoint start;
@property (nonatomic,assign)CGPoint end;
@end
