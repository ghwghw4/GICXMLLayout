//
//  GICRegeneratorRuntime.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/27.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICRegeneratorRuntime <JSExport>
+(JSValue *)mark:(JSValue *)funcName;
+(id)wrap:(JSValue *)func :(JSValue *)markValue :(JSValue *)target;
@end


/**
 实现一套RegeneratorRuntime，配合yield以及enerator，符合ES6
 */
@interface GICRegeneratorRuntime : NSObject<GICRegeneratorRuntime>

@end
