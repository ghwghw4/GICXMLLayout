//
//  JSLocalStorage.m
//  HouseProperty
//
//  Created by 龚海伟 on 2018/11/20.
//  Copyright © 2018年 龚海伟. All rights reserved.
//

#import "JSLocalStorage.h"


@implementation JSLocalStorage

+ (NSString *)getItem:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)setItem:(NSString *)key value:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

+(void)removeItem:(NSString *)key;{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
@end
