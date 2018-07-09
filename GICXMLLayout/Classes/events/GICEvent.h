//
//  GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <Foundation/Foundation.h>

@interface GICEvent : NSObject{
    NSString *expressionString;
}
@property (nonatomic,weak)id target;
@property (nonatomic,readonly,strong)RACSubject *eventSubject;

-(void)onAttachTo:(id)target;

-(id)initWithExpresion:(NSString *)expresion;

-(RACSignal *)createEventSignal;
@end
