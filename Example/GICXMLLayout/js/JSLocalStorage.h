//
//  JSLocalStorage.h
//  HouseProperty
//
//  Created by 龚海伟 on 2018/11/20.
//  Copyright © 2018年 龚海伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSLocalStorage <JSExport>
JSExportAs(setItem, + (void)setItem:(NSString *)key value:(NSString *)value);
+(NSString *)getItem:(NSString *)key;
+(void)removeItem:(NSString *)key;
@end

@interface JSLocalStorage : NSObject<JSLocalStorage>

@end
