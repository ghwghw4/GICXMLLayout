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

+(instancetype)createBindingFromExpression:(NSString *)expString{
    GICDataBinding *b = [GICDataBinding new];
    
    NSString *regularString = expString;
    if([regularString characterAtIndex:regularString.length - 1] != ','){
        regularString = [regularString stringByAppendingString:@","];
    }
    
    NSString *exp = [self getBindingPartString:regularString key:@"exp"];
    if(exp){//解析表达式
        b.expression = exp;
        // 解析mode
        NSString *mode = [[self getBindingPartString:regularString key:@"mode"] lowercaseString];
        if(mode){
            if([mode isEqualToString:@"0"] || [mode isEqualToString:@"once"]){
                b.bingdingMode = GICBingdingMode_Once;
            }else if([mode isEqualToString:@"1"] || [mode isEqualToString:@"oneway"]){
                b.bingdingMode = GICBingdingMode_OneWay;
            }else if([mode isEqualToString:@"2"] || [mode isEqualToString:@"towway"]){
                b.bingdingMode = GICBingdingMode_TowWay;
            }
        }
    }else{
         b.expression = expString;
    }
    return b;
}

+(NSString *)getBindingPartString:(NSString *)regularString key:(NSString *)keyname{
    NSString *re = [GICUtils regularMatchFirst:regularString pattern:[NSString stringWithFormat:@"%@\s*=(.*?),",keyname]];
    if(re){
        NSString *tmp = [GICUtils regularMatchFirst:re pattern:[NSString stringWithFormat:@"%@\s*=",keyname]];
        return [[re stringByReplacingOccurrencesOfString:tmp withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
    }
    return nil;
}

-(void)refreshExpression{
    JSContext *context = [[JSContext alloc] init];
     NSString *jsCode = self.expression;
    if(self.expression.length==0){
        context[@"$original_data"] = self.dataSource;
        jsCode = @"$original_data";
        JSValue *value = [context evaluateScript:jsCode];
        self.valueConverter.propertySetter(self.target,[value toString]);
        return;
    }
    // 将数据源解析成纯dictionary
    NSDictionary *dict = [GICJsonParser objectSerializeToJsonDictionary:self.dataSource];
    if(dict){
        for(NSString *key in dict.allKeys){
            id value = [dict objectForKey:key];
            context[key] = value;
        }
    }
    JSValue *value = [context evaluateScript:jsCode];
    self.valueConverter.propertySetter(self.target,[self.valueConverter convert:[value toString]]);
    
    if(!self.isInitBinding){
        if(self.bingdingMode == GICBingdingMode_Once){
            return;
        }
        // 创建数据绑定
        for(NSString *key in dict.allKeys){
            if([self.expression containsString:key]){
                @weakify(self)
                [[self.dataSource rac_valuesAndChangesForKeyPath:key options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
                    @strongify(self)
                    [self refreshExpression];
                }];
            }
        }
        
        // 处理双向绑定
        if(self.bingdingMode == GICBingdingMode_TowWay){
            if([self.target respondsToSelector:@selector(gic_createTowWayBindingWithAttributeName:)]){
                @weakify(self)
                [[self.target gic_createTowWayBindingWithAttributeName:self.attributeName] subscribeNext:^(id  _Nullable newValue) {
                    @strongify(self)
                    // 判断原值和新值是否一致，只有在不一致的时候才会触发更新
                    if(![newValue isEqual:[self.dataSource objectForKey:self.expression]]){
                        // 将新值更新到数据源
                        [self.dataSource setValue:newValue forKey:self.expression];
                    }
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
