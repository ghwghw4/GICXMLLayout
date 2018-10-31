//
//  GICJSPopover.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/30.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "GICPopover.h"
@protocol GICJSPopover <JSExport>
-(void)present:(BOOL)animation;

// 隐藏弹框
-(void)dismiss:(BOOL)animation;

JSExportAs(create, +(instancetype)create:(NSString *)templateName fromElement:(id)element);
@end

@interface GICJSPopover : NSObject<GICJSPopover>

@end
