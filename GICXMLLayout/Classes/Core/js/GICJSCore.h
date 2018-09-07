//
//  GICJSCore.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface GICJSCore : NSObject
+(GICJSCore*)shared;
-(void)extend:(JSContext*)context;
-(void)extend:(JSContext*)context logHandler:(void (^)(NSString* logLevel,NSArray* params,NSString* formatedLogEntry))logHandler;
@end
