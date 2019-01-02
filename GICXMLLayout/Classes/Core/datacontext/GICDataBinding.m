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
        
        #if DEBUG
        // 开启定时器，定时清理JS内存
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(dataBindingJSContextTimerTick) userInfo:nil repeats:YES];
        });
        #endif
    });
    return context;
}

+(void)dataBindingJSContextTimerTick{
     [[self jsDataBindingContext] evaluateScript:@"gc.collect(true);"];
}

-(void)setValueFromJSValue:(JSValue *)jsvalue{
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
}

-(void)refreshExpression{
    if(!self.target)
        return;
    JSContext *context =[GICDataBinding jsDataBindingContext];
    NSString *jsCode = self.expression;
    if(self.expression.length==0){
        context[@"$original_data"] = self.dataSource;
        jsCode = @"$original_data";
        JSValue *jsvalue = [context evaluateScript:jsCode];
        [self setValueFromJSValue:jsvalue];
        return;
    }
    
    JSValue *dsJSValue = [JSValue valueWithObject:self.dataSource inContext:context];
    NSArray *allKeys = nil;
    if([self.dataSource isKindOfClass:[NSDictionary class]]){
        allKeys = [(NSDictionary *)self.dataSource allKeys];
        // TODO:为了效率考虑，字典并没有采用注入属性的方法，但是这样一来会有一个bug，那就是如果字典中存储的是某个`class`的实例对象，那么就有可能会出现访问不到属性的情况。后续解决
    }else{
        allKeys = [[self.dataSource class] gic_reflectProperties].allKeys;
        [dsJSValue invokeMethod:@"_elementInit2" withArguments:@[allKeys]];
        dsJSValue[@"getAttValue"] = ^(JSValue *attName){
            // TODO:这一步其实也是要做_elementInit2处理的
            return [self.dataSource valueForKey:[attName toString]];
        };
    }
   
    JSValue *jsvalue = [dsJSValue invokeMethod:@"executeBindExpression2" withArguments:@[allKeys,[NSString stringWithFormat:@"return %@",self.expression],dsJSValue]];
   [self setValueFromJSValue:jsvalue];
    
    if(!self.isInitBinding){
        if(self.bingdingMode == GICBingdingMode_Once){
            return;
        }
        // 创建数据绑定
        for(NSString *key in allKeys){
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


