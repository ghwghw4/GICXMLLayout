//
//  AutoHideKeybordBehavior.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "AutoHideKeybordBehavior.h"

@implementation AutoHideKeybordBehavior
+(NSString *)gic_elementName{
    return @"bev-hidekeybord";
}

-(void)attachTo:(UIViewController *)target{
    [super attachTo:target];
    if([target isKindOfClass:[UIViewController class]]){
        UITapGestureRecognizer *ges =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTapGes:)];
        self->target = target;
        // 必须在UI线程访问view
        dispatch_async(dispatch_get_main_queue(), ^{
             [target.view addGestureRecognizer:ges];
        });
    }
}

-(void)handelTapGes:(UITapGestureRecognizer *)ges{
    if(ges.state == UIGestureRecognizerStateEnded){
         [self->target.view endEditing:YES];
    }
}
@end
