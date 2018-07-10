//
//  NSObject+GICDataBinding.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import "NSObject+GICDataBinding.h"
#import "NSObject+GICDataContext.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSObject+GICDirective.h"


/**
 专门提供给data-model做绑定用的。对于data-model的绑定，绑定类型固定是one-way
 */
@interface GICDataModelBinding_ : GICDataBinding

@end

@implementation GICDataModelBinding_
-(GICBingdingMode)bingdingMode{
    return GICBingdingMode_OneWay;
}

-(void)refreshExpression{
    if(!self.isInitBinding){
        @weakify(self)
        [[self.dataSource rac_valuesAndChangesForKeyPath:[self.target gic_dataPathKey] options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self.target gic_updateDataContext:self.dataSource];
        }];
    }
}
@end


@interface NSObject (GICDataBinding2)
@property (nonatomic,strong)GICDataModelBinding_ *gic_dataModelBinding;
@end


@implementation NSObject (GICDataBinding)
-(NSArray<GICDataBinding *> *)gic_Bindings{
   return objc_getAssociatedObject(self, "gic_Bindings");
}

-(void)gic_addBinding:(GICDataBinding *)binding{
    if(binding==nil)
        return;
    NSMutableArray<GICDataBinding *> * bindings= (NSMutableArray<GICDataBinding *> *)self.gic_Bindings;
    if(bindings==nil){
        bindings = [NSMutableArray array];
        objc_setAssociatedObject(self, "gic_Bindings", bindings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [bindings addObject:binding];
}

-(void)setGic_dataModelBinding:(GICDataModelBinding_ *)gic_dataModelBinding{
    objc_setAssociatedObject(self, "gic_dataModelBinding", gic_dataModelBinding, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(GICDataModelBinding_ *)gic_dataModelBinding{
    return objc_getAssociatedObject(self, "gic_dataModelBinding");
}



-(void)gic_updateDataContext:(id)superDataContenxt{
    if(self.gic_dataPathKey && ![superDataContenxt isKindOfClass:[NSArray class]]){ //以防array 无法获取value
        id v = [superDataContenxt valueForKey:self.gic_dataPathKey];
        if(![GICUtils isNull:v]){
            if(self.gic_DataContenxt !=v){
                self.gic_DataContenxt = v;
                // 创建绑定
                GICDataModelBinding_ *tmp = self.gic_dataModelBinding;
                if(tmp==nil){
                    tmp = [GICDataModelBinding_ new];
                    tmp.target = self;
                    self.gic_dataModelBinding = tmp;
                }
                [tmp updateDataSource:superDataContenxt];
                // 以便更新当前object的绑定
                superDataContenxt = v;
            }
        }
    }
    
    for(GICDataBinding *b in self.gic_Bindings){
        [b updateDataSource:superDataContenxt];
    }
    
    for(GICDirective *d in self.gic_directives){
        [d gic_updateDataContext:superDataContenxt];
//        [d updateDataSource:superDataContenxt];
    }
    
    if([self respondsToSelector:@selector(gic_subElements)]){
        for(NSObject *sub in [self performSelector:@selector(gic_subElements)]){
            if(sub.gic_isAutoInheritDataModel){
                 [sub gic_updateDataContext:superDataContenxt];
            }
        }
    }
}
@end
