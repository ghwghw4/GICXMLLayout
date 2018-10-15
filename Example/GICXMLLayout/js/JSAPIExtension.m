//
//  JSAPIExtension.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/10/15.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "JSAPIExtension.h"
#import "JSAlert.h"

@implementation JSAPIExtension
+(void)registeJSAPIToJSContext:(JSContext*)context{
    context[@"AlertView"] = [JSAlert class];
}
@end
