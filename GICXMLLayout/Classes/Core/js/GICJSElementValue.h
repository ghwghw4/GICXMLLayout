//
//  GICJSElementValue.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICJSElementValue <JSExport>
@property JSValue* dataSource;
// 获取元素属性值
-(id)getAttValue:(NSString *)attName;

-(JSValue *)getSuperElement:(JSValue *)selfValue;

// 设置元素属性值
JSExportAs(setAttValue, - (void)setAttValue:(NSString *)attName newValue:(NSString *)newValue);

// 注册事件
JSExportAs(setEvent, - (void)setEvent:(NSString *)eventName eventFunc:(JSValue *)eventFunc);
@end

@interface GICJSElementValue : NSObject<GICJSElementValue>
@property (nonatomic,weak,readonly)id element;

+(JSValue *)creatValueFrom:(id)element toContext:(id)jsContext;
@end
