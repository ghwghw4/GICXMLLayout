//
//  GICDataBinding.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import "GICDataBinding.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation GICDataBinding
-(void)update{
    JSContext *context = [[JSContext alloc] init];
    for(NSString *key in [self.dataSource allKeys]){
        id value = [self.dataSource objectForKey:key];
        context[key] = value;
    }
    NSString *jsCode = self.expression;
    JSValue *value = [context evaluateScript:jsCode];
    if(value)
        self.valueConverter.propertySetter(self.target,[value toString]);
}
@end
