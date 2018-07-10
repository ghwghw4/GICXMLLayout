//
//  GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <Foundation/Foundation.h>

@interface GICEvent : NSObject{
    NSString *expressionString;
    RACDisposable *signlDisposable;
}
@property (nonatomic,weak)id target;
@property (nonatomic,readonly,strong)RACSubject *eventSubject;
-(id)initWithExpresion:(NSString *)expresion;

/**
 绑定事件

 @param target <#target description#>
 */
-(void)attachTo:(id)target;

/**
 取消绑定事件。由子实现类取消事件
 */
-(void)unAttach;

/**
 创建事件信号，由子类实现

 @return <#return value description#>
 */
-(RACSignal *)createEventSignal;
@end
