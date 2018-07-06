//
//  NSObject+GICDirective.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "NSObject+GICDirective.h"
#import <objc/runtime.h>

@implementation NSObject (GICDirective)

-(NSArray<GICDirective *> *)gic_directives{
    return objc_getAssociatedObject(self, "gic_directives");
}

-(void)gic_addDirective:(GICDirective *)directive{
    if(directive==nil)
        return;
    NSMutableArray<GICDirective *> * dirs= (NSMutableArray<GICDirective *> *)self.gic_directives;
    if(dirs==nil){
        dirs = [NSMutableArray array];
        objc_setAssociatedObject(self, "gic_directives", dirs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [dirs addObject:directive];
    directive.target = self;
}
@end
