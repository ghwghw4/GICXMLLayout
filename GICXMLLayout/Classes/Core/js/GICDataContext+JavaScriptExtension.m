//
//  GICDataContext+JavaScriptExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/17.
//

#import "GICDataContext+JavaScriptExtension.h"
#import "JSValue+GICJSExtension.h"
#import "NSObject+GICDataBinding.h"
#import "GICJSElementDelegate.h"
#import "GICXMLLayoutPrivate.h"

@implementation NSObject (JSScriptDataBinding)
-(void)gic_updateDataContextFromJsValue:(JSManagedValue *)jsValue{
    if([jsValue.value isNull])
        return;
    if([self gic_dataPathKey] && [jsValue.value isObject]){ //以防array 无法获取value
        JSValue *pathValue = jsValue.value[[self gic_dataPathKey]];
        if(![pathValue isUndefined]){
            // 用来监听gic_dataPathKey对应的属性改变事件
            JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self inContext:[jsValue.value context]];
            @weakify(self)
            selfValue[@"_updateBindPath"] = ^(JSValue *value){
                @strongify(self)
                [self gic_updateDataContext:[value gic_ToManagedValue:self]];
            };
            [jsValue.value invokeMethod:@"addElementBind" withArguments:@[selfValue,[self gic_dataPathKey],@"_updateBindPath"]];
            jsValue = [pathValue gic_ToManagedValue:self];
        }else{
            jsValue = [pathValue gic_ToManagedValue:self];
        }
    }
    
    for(GICDataBinding *b in [self gic_Bindings]){
        [b gic_updateDataContext:jsValue];
    }
    
    for(GICBehavior *d in [self gic_Behaviors].behaviors){
        [d gic_updateDataContext:jsValue];
    }
    
    for(id e in [self gic_subElements]){
        if([e gic_isAutoInheritDataModel]){
            [e gic_updateDataContext:jsValue];
        }
    }
}
@end



@implementation GICDirectiveFor (JSScriptExtension)
//-(void)gic_updateDataContextFromJsValue:(JSValue *)jsValue{
//    [super gic_updateDataContextFromJsValue:jsValue];
//    [self updateDataSourceFromJsValue:jsValue];
//}

-(void)updateDataSourceFromJsValue:(JSManagedValue *)jsValue{
    [self removeAllItems];
    if([[jsValue.value invokeMethod:@"isArray" withArguments:nil] toBool]){
        jsValue.value[@"forDirective"] = self;
        [jsValue.value invokeMethod:@"toForDirector" withArguments:@[jsValue.value[@"forDirective"]]];
    }
}
- (void)addItem:(JSValue *)item index:(NSInteger)index {
    dispatch_async([GICXMLLayout parseElementQueue], ^{
        NSObject *childElement = [NSObject gic_createElement:[self->xmlDoc rootElement] withSuperElement:self.target];
        childElement.gic_isAutoInheritDataModel = NO;
        childElement.gic_DataContext = [item gic_ToManagedValue:self.target];
        childElement.gic_ExtensionProperties.elementOrder = self.gic_ExtensionProperties.elementOrder + index*kGICDirectiveForElmentOrderStart;
        childElement.gic_ExtensionProperties.isFromDirectiveFor = YES;
        [self.target gic_addSubElement:childElement];
    });
}

- (void)insertItem:(JSValue *)item index:(NSInteger)index{
    // TODO:inset
}

-(void)deleteItemWithIndex:(NSInteger)index{
    NSArray *items =  [self.target gic_subElements];
    if(index>=0  && index < items.count){
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
-(void)refreshExpressionFromJSValue:(JSManagedValue *)jsValue needCheckMode:(BOOL)needCheckMode{
    NSString *resultString = nil;
    JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self.target inContext:[jsValue.value context]];
    if(self.expression.length == 0){
        resultString = [jsValue.value toString];
    }else{
        NSString *js = [NSString stringWithFormat:@"return %@",self.expression];
        JSValue *result = [jsValue.value invokeMethod:@"executeBindExpression" withArguments:@[js,selfValue]];
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
            [self refreshExpressionFromJSValue:[value gic_ToManagedValue:self.target] needCheckMode:NO];
    };
    [jsValue.value invokeMethod:@"addElementBind" withArguments:@[selfValue,self.expression,@"_updateBindExp"]];
    
    // 实现双向绑定
    if(self.bingdingMode == GICBingdingMode_TowWay){
        if([self.target respondsToSelector:@selector(gic_createTowWayBindingWithAttributeName:withSignalBlock:)]){
            @weakify(self)
            [self.target gic_createTowWayBindingWithAttributeName:self.attributeName withSignalBlock:^(RACSignal *signal) {
                [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable newValue) {
                    // 判断原值和新值是否一致，只有在不一致的时候才会触发更新
                    @strongify(self)
                    isTowwayUpdate = YES;
                    jsValue.value[self.expression] = newValue;
                    isTowwayUpdate = NO;
                }];
            }];
        }
    }
}
@end




@implementation GICEvent(JSScriptExtension)
-(void)excuteJSBindExpress:(NSString *)js withValue:(id)value{
    JSValue *selfValue = [GICJSElementDelegate getJSValueFrom:self.target inContext:nil];
    if(value){
        NSString *newJs = [NSString stringWithFormat:@"var $eventInfo = arguments[0]; %@",js];
        [selfValue invokeMethod:@"executeScript" withArguments:@[newJs,value]];
    }else{
        [selfValue invokeMethod:@"executeScript" withArguments:@[js]];
    }
}
@end

