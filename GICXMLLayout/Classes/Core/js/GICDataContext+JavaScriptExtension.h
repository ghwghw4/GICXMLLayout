//
//  GICDataContext+JavaScriptExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/17.
//



#import <JavaScriptCore/JavaScriptCore.h>
#import "GICDataBinding.h"
#import "GICDirectiveFor.h"


// 主要是对数据源的扩展


@interface NSObject (JSScriptDataBinding)
-(void)gic_updateDataContextFromJsValue:(JSManagedValue *)jsValue;
@end

@interface GICDataBinding (JSScriptExtension)
-(void)refreshExpressionFromJSValue:(JSManagedValue *)jsValue needCheckMode:(BOOL)needCheckMode;
@end

@protocol GICJSForDirective <JSExport>
JSExportAs(addItem, - (void)addItem:(JSValue *)item index:(NSInteger)index);
JSExportAs(insertItem, - (void)insertItem:(JSValue *)item index:(NSInteger)index);
-(void)deleteItemWithIndex:(NSInteger)index;
-(void)deleteAllItems;
@end

@interface GICDirectiveFor (JSScriptExtension)<GICJSForDirective>
-(void)updateDataSourceFromJsValue:(JSManagedValue *)jsValue;
@end


@interface GICEvent(JSScriptExtension)
-(void)excuteJSBindExpress:(NSString *)js withValue:(id)value;
@end
