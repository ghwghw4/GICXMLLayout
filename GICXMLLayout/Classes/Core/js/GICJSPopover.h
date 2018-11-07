//
//  GICJSPopover.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "GICPopover.h"
#import "GICJSElementDelegate.h"

//JSPopover 的JSContext跟宿主共享同一个JSContext。但是不共享数据源
@protocol GICJSPopover <JSExport>
-(void)present:(BOOL)animation;

// 隐藏弹框
-(void)dismiss:(BOOL)animation;

JSExportAs(createPage, +(instancetype)createPage:(NSString *)pagePath fromElement:(GICJSElementDelegate *)element);
@end

@interface GICJSPopover : NSObject<GICJSPopover>

@end
