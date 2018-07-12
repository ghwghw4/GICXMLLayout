//
//  GICBehavior.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/12.
//

#import <Foundation/Foundation.h>

/**
 提供element各种行为的基类
 */
@interface GICBehavior : NSObject

/**
 是否一次性的行为,默认false
 如果初始化的时候设为Yes,那么attach完毕后立马会调用unattach移除
 */
@property (nonatomic,assign)BOOL isOnce;

/**
 将Behavior附加到目标
 @param target <#target description#>
 */
-(void)attachTo:(id)target;

/**
 移除Behavior
 */
-(void)unattach;
@end
