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
#import <GICJsonParser/NSObject+Reflector.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "GICDataContext+JavaScriptExtension.h"
#import "GICJSCore.h"


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
        
        NSString *converterClassString = [self getBindingPartString:regularString key:@"cvt"];
        if(converterClassString){
            Class converterClass = NSClassFromString(converterClassString);
            if(converterClass){
                id converter = [converterClass new];
                if([converter isKindOfClass:[GICDataBingdingValueConverter class]]){
                     b.valueConverter = converter;
                }
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

+(JSContext *)jsDataBindingContext{
    static JSContext *context = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[JSContext alloc] init];
        [GICJSCore extend:context];
        // 开启定时器，定时清理JS内存
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(dataBindingJSContextTimerTick) userInfo:nil repeats:YES];
        });
    });
    return context;
}

+(void)dataBindingJSContextTimerTick{
     [[self jsDataBindingContext] evaluateScript:@"gc.collect(true);"];
}

-(void)refreshExpression{
    JSContext *context =[GICDataBinding jsDataBindingContext];
    NSString *jsCode = self.expression;
    if(self.expression.length==0){
        context[@"$original_data"] = self.dataSource;
        jsCode = @"$original_data";
        JSValue *value = [context evaluateScript:jsCode];
        self.attributeValueConverter.propertySetter(self.target,[value toString]);
        return;
    }
    
    JSValue *dsJSValue = [JSValue valueWithObject:self.dataSource inContext:context];
    JSValue *jsvalue = [dsJSValue invokeMethod:@"executeBindExpression" withArguments:@[[NSString stringWithFormat:@"return %@",self.expression],dsJSValue]];
    NSString *valueString = [jsvalue isUndefined]?@"":[jsvalue toString];
    id value = nil;
    if(self.valueConverter){
        value = [self.valueConverter convert:valueString];
    }else{
        value = [self.attributeValueConverter convert:valueString];
    }
    self.attributeValueConverter.propertySetter(self.target,value);
    if(self.valueUpdate){
        self.valueUpdate(value);
    }
    
    if(!self.isInitBinding){
        if(self.bingdingMode == GICBingdingMode_Once){
            return;
        }
        // 创建数据绑定
        for(NSString *key in [[self.dataSource class] gic_reflectProperties].allKeys){
            if([self.expression rangeOfString:key].location != NSNotFound){
                @weakify(self)
                [[self.dataSource rac_valuesAndChangesForKeyPath:key options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
                    @strongify(self)
                    if(self.bingdingMode == GICBingdingMode_TowWay){
                        if([x[0] isEqual:[self.dataSource valueForKey:self.expression]]){
                            // 将新值更新到数据源
                            return;
                        }
                    }
                    [self refreshExpression];
                }];
            }
        }
        
        // 处理双向绑定
        if(self.bingdingMode == GICBingdingMode_TowWay){
            if([self.target respondsToSelector:@selector(gic_createTowWayBindingWithAttributeName:withSignalBlock:)]){
                @weakify(self)
                [self.target gic_createTowWayBindingWithAttributeName:self.attributeName withSignalBlock:^(RACSignal *signal) {
                    [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable newValue) {
                        @strongify(self)
                        // 判断原值和新值是否一致，只有在不一致的时候才会触发更新
                        if(![newValue isEqual:[self.dataSource valueForKey:self.expression]]){
                            // 将新值更新到数据源
                            [self.dataSource setValue:newValue forKey:self.expression];
                        }
                    }];
                }];
            }
        }
    }
}

-(void)gic_updateDataContext:(id)dataSource{
    if(_dataSource !=dataSource){
        _isInitBinding = NO;
        _dataSource = dataSource;
        // 支持JS 数据源
        if([self.dataSource isKindOfClass:[JSManagedValue class]]){
            // 这部分逻辑完全交与扩展方法即可
            [self refreshExpressionFromJSValue:self.dataSource needCheckMode:YES];
        }else{
            [self refreshExpression];
        }
        _isInitBinding = YES;
    }
}

@end


