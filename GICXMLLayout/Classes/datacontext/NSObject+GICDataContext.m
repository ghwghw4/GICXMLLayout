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


@end
