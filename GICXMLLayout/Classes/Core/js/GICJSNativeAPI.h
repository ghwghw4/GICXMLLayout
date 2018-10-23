//
//  GICJSNativeAPI.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/19.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICJSNativeAPI <JSExport>
//创建对象
JSExportAs(createObject, -(id)createObject:(NSString *)className arguments:(NSArray<JSValue *>*)arguments);
// 调用native实例的方法
JSExportAs(callMethod, -(id)callMethod:(id)object methodName:(NSString *)methodName arguments:(NSArray*)arguments);
// 调用native静态的方法
JSExportAs(callMethodStatic, -(id)callMethodStatic:(NSString *)className methodName:(NSString *)methodName arguments:(NSArray*)arguments);

JSExportAs(setProperty, -(void)setProperty:(id)object propertyName:(NSString *)propertyName value:(id)value);

-(JSValue *)defineClass:(NSString *)className;
@end

@interface GICJSNativeAPI : NSObject<GICJSNativeAPI>

@end
