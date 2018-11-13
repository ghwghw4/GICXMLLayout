//
//  GICJSElementDelegate.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/7.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICJSElementDelegate <JSExport>
// 数据源。用来做绑定的
@property JSValue* dataContext;
// 获取元素属性值
-(id)_getAttValue:(NSString *)attName;

// 设置元素属性值
JSExportAs(_setAttValue, - (void)_setAttValue:(NSString *)attName newValue:(NSString *)newValue);

// 注册事件
JSExportAs(_setEvent, - (void)_setEvent:(NSString *)eventName eventFunc:(JSValue *)eventFunc);

-(JSValue *)_getSuperElement;
// 获取当前元素的子元素
-(NSArray *)subElements;

-(void)removeFromSupeElement;

-(instancetype)init;
@end


/**
 用于元素跟JS之间交互的代理中间件
 */
@interface GICJSElementDelegate : NSObject<GICJSElementDelegate>
@property (nonatomic,weak,readonly)id element;
@property (nonatomic,readonly)NSString *variableName;// 变量名称

+(JSValue *)getJSValueFrom:(id)element inContext:(id)jsContext;
@end
