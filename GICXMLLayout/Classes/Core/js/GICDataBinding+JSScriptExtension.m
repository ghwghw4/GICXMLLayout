//
//  GICDataBinding+JSScriptExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/13.
//

#import "GICDataBinding+JSScriptExtension.h"
#import "GICJSElementValue.h"
#import "NSObject+GICDataBinding.h"

/**
 实现js 跟 native 之间的数据绑定
 */
@implementation GICDataBinding (JSScriptExtension)
-(void)refreshExpressionFromJSValue:(JSValue *)jsValue needCheckMode:(BOOL)needCheckMode{
    NSString *resultString = nil;
    JSValue *selfValue = [GICJSElementValue getJSValueFrom:self.target inContext:[jsValue context]];
    if(self.expression.length == 0){
        resultString = [jsValue toString];
    }else{
        NSString *js = [NSString stringWithFormat:@"return %@",self.expression];
        JSValue *result = [jsValue invokeMethod:@"executeBindExpression" withArguments:@[js,selfValue]];
        resultString = [result isUndefined]?@"":[result toString];
    }
    id value = nil;
    if(self.valueConverter){
        value = [self.valueConverter convert:resultString];
    }else{
        value = [self.attributeValueConverter convert:resultString];
    }
    self.attributeValueConverter.propertySetter(self.target,value);
    if(self.valueUpdate){
        self.valueUpdate(value);
    }
    if(!needCheckMode || self.bingdingMode == GICBingdingMode_Once){
        return;
    }
    
    __block BOOL isTowwayUpdate = NO;
    // 实现单向绑定
    @weakify(self)
    selfValue[@"_updateBindExp"] = ^(JSValue *value){
        @strongify(self)
        if(!isTowwayUpdate)
            [self refreshExpressionFromJSValue:value needCheckMode:NO];
    };
    [jsValue invokeMethod:@"addElementBind" withArguments:@[selfValue,self.expression,@"_updateBindExp"]];
    
    // 实现双向绑定
    if(self.bingdingMode == GICBingdingMode_TowWay){
        if([self.target respondsToSelector:@selector(gic_createTowWayBindingWithAttributeName:withSignalBlock:)]){
            JSValue *weakJsValue = jsValue;
            @weakify(self)
            [self.target gic_createTowWayBindingWithAttributeName:self.attributeName withSignalBlock:^(RACSignal *signal) {
                [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable newValue) {
                    // 判断原值和新值是否一致，只有在不一致的时候才会触发更新
                    // TODO:这里可能会引起内存异常，因为这里对jsValue捕获了，因此要想办法修改
                    @strongify(self)
                    isTowwayUpdate = YES;
                    weakJsValue[self.expression] = newValue;
                    isTowwayUpdate = NO;
                }];
            }];
        }
    }
}

-(void)updateDataSourceFromJsValue:(JSValue *)jsValue{
    [self refreshExpressionFromJSValue:jsValue needCheckMode:YES];
}


+(void)updateDataContextFromJsValue:(JSValue *)jsValue element:(id)element{
    if([element gic_dataPathKey] && [jsValue isObject]){ //以防array 无法获取value
        JSValue *pathValue = jsValue[[element gic_dataPathKey]];
        if(![pathValue isUndefined]){
            // 用来监听gic_dataPathKey对应的属性改变事件
            JSValue *selfValue = [GICJSElementValue getJSValueFrom:element inContext:[jsValue context]];
            selfValue[@"_updateBindPath"] = ^(JSValue *value){
                [self updateDataContextFromJsValue:value element:element];
            };
            [jsValue invokeMethod:@"addElementBind" withArguments:@[selfValue,[element gic_dataPathKey],@"_updateBindPath"]];
            jsValue = pathValue;
        }else{
            jsValue = pathValue;
        }
    }
    
    for(GICDataBinding *b in [element gic_Bindings]){
        [b updateDataSourceFromJsValue:jsValue];
    }
    
    for(id e in [element gic_subElements]){
        [self updateDataContextFromJsValue:jsValue element:e];
    }
}

@end
