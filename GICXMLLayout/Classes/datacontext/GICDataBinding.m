//
//  GICDataBinding.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import "GICDataBinding.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "NSObject+GICDataBinding.h"
#import <GICJsonParser/GICJsonParser.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface GICDataBinding(){
    
}
@end

@implementation GICDataBinding
-(void)refreshExpression{
    JSContext *context = [[JSContext alloc] init];
    NSDictionary *dict = [GICJsonParser objectSerializeToJsonDictionary:self.dataSource];
    for(NSString *key in dict.allKeys){
        id value = [dict objectForKey:key];
        context[key] = value;
    }
    NSString *jsCode = self.expression;
    JSValue *value = [context evaluateScript:jsCode];
    if(value)
        self.valueConverter.propertySetter(self.target,[value toString]);
    
    if(!self.isInitBinding){
//        if(self.bingdingMode == GICBingdingMode_Once){
//            return;
//        }
        for(NSString *key in dict.allKeys){
            if([self.expression containsString:key]){
                @weakify(self)
                [[self.dataSource rac_valuesAndChangesForKeyPath:key options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
                    @strongify(self)
                    [self refreshExpression];
                }];
            }
        }
    }
}

-(void)updateDataSource:(id)dataSource{
    if(_dataSource !=dataSource){
        _isInitBinding = NO;
        _dataSource = dataSource;
        [self refreshExpression];
        _isInitBinding = YES;
    }
}
@end
