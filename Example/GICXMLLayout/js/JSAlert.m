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
    [alertVC addAction:[UIAlertAction actionWithTitle:buttonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [callback callWithArguments:nil];
    }]];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
