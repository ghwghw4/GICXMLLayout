//
//  JSContext+GICJSContext.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/12.
//

#import "JSContext+GICJSContext.h"

@implementation JSContext (GICJSContext)
-(void)setRootDataContext:(JSValue *)dataContext{
    self[@"__rootDataContext__"] = dataContext;
}

-(JSValue *)rootDataContext{
    return self[@"__rootDataContext__"];
}

-(BOOL)isSetRootDataContext{
    return ![[self rootDataContext] isUndefined];
}
@end
