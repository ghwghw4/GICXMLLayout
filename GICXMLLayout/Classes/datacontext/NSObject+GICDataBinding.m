//
//  NSObject+GICDataBinding.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import "NSObject+GICDataBinding.h"
#import "NSObject+GICDataContext.h"
#import <objc/runtime.h>

@implementation UIView (GICDataBinding)
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



-(void)gic_updateDataBinding:(id)dataContenxt{
    if(self.gic_dataModelKey){
        id v = [dataContenxt objectForKey:self.gic_dataModelKey];
        if(v){
            self.gic_DataContenxt = v;
            return;
        }
    }
    
    for(GICDataBinding *b in self.gic_Bindings){
        b.dataSource = dataContenxt;
        [b update];
    }
    for(UIView *subV in self.subviews){
        [subV gic_updateDataBinding:dataContenxt];
    }
}
@end
