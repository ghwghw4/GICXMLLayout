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
-(void)setGic_DataContext:(id)gic_DataContext{
    [self setGic_DataContext:gic_DataContext updateBinding:YES];
}
static const char* GICDataContextPropertyKey = "gic_DataContext";
-(void)setGic_DataContext:(id)gic_DataContext updateBinding:(BOOL)update{
    objc_setAssociatedObject(self, GICDataContextPropertyKey, gic_DataContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //将数据源的owner设为self
    [gic_DataContext gic_ExtensionProperties].superElement = self;
    if(update)
        [self gic_updateDataContext:gic_DataContext];
}

-(id)gic_DataContext{
    return [self gic_DataContenxtIgnorNotAutoInherit:NO];
}

-(id)gic_self_dataContext{
    return objc_getAssociatedObject(self, GICDataContextPropertyKey);
}

-(id)gic_DataContenxtIgnorNotAutoInherit:(BOOL)isIgnorNotAutoInherit{
    id dc = nil;
    if(!isIgnorNotAutoInherit || self.gic_isAutoInheritDataModel){
        dc = objc_getAssociatedObject(self, GICDataContextPropertyKey);
    }
    if(dc){
        return dc;
    }
    return [[self gic_getSuperElement] gic_DataContenxtIgnorNotAutoInherit:isIgnorNotAutoInherit];
    return nil;
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
