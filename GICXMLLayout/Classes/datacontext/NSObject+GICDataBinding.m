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
        [[self.dataSource rac_valuesAndChangesForKeyPath:[self.target gic_dataModelKey] options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self.target gic_updateDataBinding:self.dataSource];
        }];
    }
}
@end


@interface NSObject (GICDataBinding2)
@property (nonatomic,strong)GICDataModelBinding_ *gic_dataModelBinding;
@end


@implementation NSObject (GICDataBinding)
-(NSMutableArray<GICDataBinding *> *)gic_Bindings{
    NSMutableArray *t = objc_getAssociatedObject(self, "gic_Bindings");
    if(t==nil){
        t = [NSMutableArray array];
        objc_setAssociatedObject(self, "gic_Bindings", t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return t;
}

-(void)setGic_dataModelKey:(NSString *)gic_dataModelKey{
    objc_setAssociatedObject(self, "gic_dataModelKey", gic_dataModelKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)gic_dataModelKey{
    return objc_getAssociatedObject(self, "gic_dataModelKey");
}

-(void)setGic_dataModelBinding:(GICDataModelBinding_ *)gic_dataModelBinding{
    objc_setAssociatedObject(self, "gic_dataModelBinding", gic_dataModelBinding, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(GICDataModelBinding_ *)gic_dataModelBinding{
    return objc_getAssociatedObject(self, "gic_dataModelBinding");
}

-(void)gic_updateDataBinding:(id)superDataContenxt{
    if(self.gic_dataModelKey){
        id v = [superDataContenxt objectForKey:self.gic_dataModelKey];
        if(v){
            if(self.gic_DataContenxt !=v){
                self.gic_DataContenxt = v;
                superDataContenxt = v;
                // 创建绑定
                GICDataModelBinding_ *tmp = self.gic_dataModelBinding;
                if(tmp==nil){
                    tmp = [GICDataModelBinding_ new];
                    tmp.target = self;
                    self.gic_dataModelBinding = tmp;
                }
                [tmp updateDataSource:superDataContenxt];
            }
        }
    }
    
    for(GICDataBinding *b in self.gic_Bindings){
        [b updateDataSource:superDataContenxt];
    }
    
    if([self respondsToSelector:@selector(gic_subElements)]){
        for(NSObject *sub in [self performSelector:@selector(gic_subElements)]){
            [sub gic_updateDataBinding:superDataContenxt];
        }
    }
}
@end
