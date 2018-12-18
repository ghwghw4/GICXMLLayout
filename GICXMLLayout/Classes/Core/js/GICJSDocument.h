//
//  GICJSDocument.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/18.
//

#import <Foundation/Foundation.h>
#import "GICJSElementDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
@protocol GICJSDocument <JSExport>
-(NSArray *)getElementsByName:(NSString *)name;
//-(JSValue *)createElementFromTemplate:(NSString *)templateName;
@property (readonly)id rootElement;


//-(id)createElement:(NSString *)elmentName;
@end

@interface GICJSDocument : NSObject<GICJSDocument>{
}
// 提供给native 调用的
//+(id)rootElement;
+(id)rootElementFromJsContext:(JSContext *)jscontext;

// 根据rootElement 获取rootView
+(UIView *)rootViewFromJSContenxt:(JSContext *)jscontext;
@end
