//
//  GICJSCore.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface GICJSCore : NSObject
+(JSContext *)findJSContextFromElement:(NSObject *)element;

+(void)extend:(JSContext *)context;

//两个元素共享JSContext
+(void)shareJSContext:(id)fromElement to:(id)toElement;
@end
