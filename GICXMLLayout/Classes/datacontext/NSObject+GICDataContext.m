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
-(void)setGic_dataModelKey:(NSString *)gic_dataModelKey{
    objc_setAssociatedObject(self, "gic_dataModelKey", gic_dataModelKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)gic_dataModelKey{
    return objc_getAssociatedObject(self, "gic_dataModelKey");
}

-(void)setGic_DataContenxt:(id)gic_DataContenxt{
    objc_setAssociatedObject(self, "gic_DataContenxt", gic_DataContenxt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self gic_updateUpdateContext:gic_DataContenxt];
}

-(id)gic_DataContenxt{
    return [self gic_DataContenxtIgnorNotAutoInherit:NO];
}

-(id)gic_DataContenxtIgnorNotAutoInherit:(BOOL)isIgnorNotAutoInherit{
    id dc = nil;
    if(!isIgnorNotAutoInherit || self.gic_isAutoInheritDataModel){
        dc = objc_getAssociatedObject(self, "gic_DataContenxt");
    }
    if(dc){
        return dc;
    }
    if([self respondsToSelector:@selector(gic_getSuperElement)]){
        return [[self gic_getSuperElement] gic_DataContenxtIgnorNotAutoInherit:isIgnorNotAutoInherit];
    }
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
