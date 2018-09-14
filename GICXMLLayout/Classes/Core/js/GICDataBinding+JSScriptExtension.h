//
//  GICDataBinding+JSScriptExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/13.
//


#import <JavaScriptCore/JavaScriptCore.h>
#import "GICDataBinding.h"
@interface GICDataBinding (JSScriptExtension)
+(void)updateDataContextFromJsValue:(JSValue *)jsValue element:(id)element;
@end
