//
//  GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <Foundation/Foundation.h>

@interface GICEvent : GICBehavior{
    NSString *expressionString;
    RACDisposable *signlDisposable;
}
@property (nonatomic,weak)id target;
@property (nonatomic,readonly,strong)RACSubject *eventSubject;
-(id)initWithExpresion:(NSString *)expresion;
/**
 创建事件信号，由子类实现

 @return <#return value description#>
 */
-(RACSignal *)createEventSignal;
@end
