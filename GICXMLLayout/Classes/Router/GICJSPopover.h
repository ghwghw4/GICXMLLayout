//
//  GICJSPopover.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "GICJSElementDelegate.h"

//JSPopover 的JSContext跟宿主共享同一个JSContext。但是不共享数据源
@protocol GICJSPopover <JSExport>
@property JSValue *ondismiss;
-(void)present:(BOOL)animation;

// 隐藏弹框
JSExportAs(dismiss, -(void)dismiss:(BOOL)animation params:(JSValue *)params);

//JSExportAs(createPage, +(instancetype)createPage:(NSString *)pagePath fromElement:(GICJSElementDelegate *)element);
+(instancetype)create:(NSString *)pagePath;
@end

@interface GICJSPopover : NSObject<GICJSPopover>

@end
