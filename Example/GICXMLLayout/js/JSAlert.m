//
//  JSAlert.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/10/15.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "JSAlert.h"

@implementation JSAlert{
    UIAlertController *alertVC;
}

@synthesize title;

-(id)init{
    self = [super init];
    alertVC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    return self;
}

-(void)setTitle:(NSString *)title{
    alertVC.title = title;
}

-(NSString *)title{
    return alertVC.title;
}

-(void)setMessage:(NSString *)message{
    alertVC.message = message;
}

-(NSString *)message{
    return alertVC.message;
}

- (void)addButton:(NSString *)buttonName clicked:(JSValue *)callback {
    // NOTE:采用这样的方式来处理callback，是为了避免循环引用的问题。
    JSValue *thisValue = [JSContext currentThis];
    thisValue[buttonName] = callback;
    JSManagedValue *managedThis = [JSManagedValue managedValueWithValue:thisValue];
    [alertVC addAction:[UIAlertAction actionWithTitle:buttonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JSValue *cb = managedThis.value[buttonName];
        if(![cb isUndefined]){
            [cb callWithArguments:nil];
        }
    }]];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
