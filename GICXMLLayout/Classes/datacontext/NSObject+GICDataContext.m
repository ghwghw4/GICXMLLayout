//
//  NSObject+GICDataContext.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import "NSObject+GICDataContext.h"
#import <objc/runtime.h>
#import "NSObject+GICDataBinding.h"

@implementation NSObject (GICDataContext)
-(void)setGic_DataContenxt:(id)gic_DataContenxt{
    objc_setAssociatedObject(self, "gic_DataContenxt", gic_DataContenxt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self gic_updateDataBinding:gic_DataContenxt];
}

-(id)gic_DataContenxt{
    return objc_getAssociatedObject(self, "gic_DataContenxt");
}

-(void)setGic_isAutoInheritDataModel:(BOOL)gic_isAutoInheritDataModel{
    objc_setAssociatedObject(self, "gic_isAutoInheritDataModel", @(gic_isAutoInheritDataModel), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)gic_isAutoInheritDataModel{
    id v = objc_getAssociatedObject(self, "gic_isAutoInheritDataModel");
    if(v){
        return [v boolValue];
    }
    return YES;
}

@end
