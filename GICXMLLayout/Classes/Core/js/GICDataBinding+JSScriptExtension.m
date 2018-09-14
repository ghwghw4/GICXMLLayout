//
//  GICDataBinding+JSScriptExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/13.
//

#import "GICDataBinding+JSScriptExtension.h"
#import "GICJSElementValue.h"
#import "NSObject+GICDataBinding.h"
#import "GICDirectiveFor.h"

@implementation NSObject (JSScriptDataContextExtension)
-(void)gic_updateDataContextFromJsValue:(JSValue *)jsValue{
    if([self gic_dataPathKey] && [jsValue isObject]){ //以防array 无法获取value
        JSValue *pathValue = jsValue[[self gic_dataPathKey]];
        if(![pathValue isUndefined]){
            // 用来监听gic_dataPathKey对应的属性改变事件
            JSValue *selfValue = [GICJSElementValue getJSValueFrom:self inContext:[jsValue context]];
            @weakify(self)
            selfValue[@"_updateBindPath"] = ^(JSValue *value){
                @strongify(self)
                [self gic_updateDataContextFromJsValue:value];
            };
            [jsValue invokeMethod:@"addElementBind" withArguments:@[selfValue,[self gic_dataPathKey],@"_updateBindPath"]];
            jsValue = pathValue;
        }else{
            jsValue = pathValue;
        }
    }
    
    for(GICDataBinding *b in [self gic_Bindings]){
        [b gic_updateDataContextFromJsValue:jsValue];
    }

    for(GICBehavior *d in [self gic_Behaviors].behaviors){
        [d gic_updateDataContextFromJsValue:jsValue];
    }
    
    for(id e in [self gic_subElements]){
        if([e gic_isAutoInheritDataModel]){
            [e gic_updateDataContextFromJsValue:jsValue];
        }
    }
}
@end


@protocol GICJSForDirective <JSExport>
JSExportAs(addItem, - (void)addItem:(JSValue *)item index:(NSInteger)index);
JSExportAs(insertItem, - (void)insertItem:(JSValue *)item index:(NSInteger)index);
-(void)deleteItemWithIndex:(NSInteger)index;
-(void)deleteAllItems;
@end

@interface GICDirectiveFor (JSScriptExtension)<GICJSForDirective>
@end


@implementation GICDirectiveFor (JSScriptExtension)
-(void)gic_updateDataContextFromJsValue:(JSValue *)jsValue{
    [super gic_updateDataContextFromJsValue:jsValue];
    [self updateDataSourceFromJsValue:jsValue];
}

-(void)updateDataSourceFromJsValue:(JSValue *)jsValue{
    [self.target gic_removeSubElements:[self.target gic_subElements]];//更新数据源以后需要清空原来是数据，然后重新添加数据
    if([[jsValue invokeMethod:@"isArray" withArguments:nil] toBool]){
        jsValue[@"forDirective"] = self;
        [jsValue invokeMethod:@"toForDirector" withArguments:@[jsValue[@"forDirective"]]];
    }
}
- (void)addItem:(JSValue *)item index:(NSInteger)index {
    NSObject *childElement = [NSObject gic_createElement:[self->xmlDoc rootElement] withSuperElement:self.target];
    childElement.gic_isAutoInheritDataModel = NO;
    [childElement gic_updateDataContextFromJsValue:item];
    childElement.gic_ExtensionProperties.elementOrder = self.gic_ExtensionProperties.elementOrder + index*kGICDirectiveForElmentOrderStart;
    [self.target gic_addSubElement:childElement];
}

- (void)insertItem:(JSValue *)item index:(NSInteger)index{
    
}

-(void)deleteItemWithIndex:(NSInteger)index{
    NSArray *items =  [self.target gic_subElements];
    if(index>0  && index < items.count){
        [self.target gic_removeSubElements:@[items[index]]];
    }
}

-(void)deleteAllItems{
    [self.target gic_removeSubElements:[[self.target gic_subElements] copy]];
}
@end



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

-(void)gic_updateDataContextFromJsValue:(JSValue *)jsValue{
     [self refreshExpressionFromJSValue:jsValue needCheckMode:YES];
}

+(void)updateDataContextFromJsValue:(JSValue *)jsValue element:(id)element{
    [element gic_updateDataContextFromJsValue:jsValue];
}
@end
