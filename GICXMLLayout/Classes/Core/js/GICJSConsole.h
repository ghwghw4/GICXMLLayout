//
//  GICJSConsole.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICJSConsole <JSExport>
@property (readonly) JSValue* log;
@property (readonly) JSValue* debug;
@property (readonly) JSValue* error;
@property (readonly) JSValue* info;
@property (readonly) JSValue* warn;
-(void)__write:(NSString*)logLevel :(NSArray*)params;
@end

@interface GICJSConsole : NSObject<GICJSConsole>
-(instancetype)initWithLogHandler:(void (^)(NSString*,NSArray*,NSString*))logHandler;
@end
