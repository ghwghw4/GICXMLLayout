//
//  GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface GICEvent : GICBehavior{
    NSString *expressionString;
    RACDisposable *signlDisposable;
}
@property (nonatomic,readonly,strong)RACSubject *eventSubject;
@property (nonatomic,assign,readonly)BOOL onlyExistOne;//是否一个元素上面只能存在一个。默认yes


-(id)initWithExpresion:(NSString *)expresion;

-(void)fire:(id)value;
///**
// 创建事件信号，由子类实现
//
// @return <#return value description#>
// */
//-(RACSignal *)createEventSignal;
//-(void)createEventSignal:(void (^)(RACSignal *signal))handel;
@end
