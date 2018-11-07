//
//  JSValue+GICJSExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/2.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue (GICJSExtension)
-(JSManagedValue *)gic_ToManagedValue:(id)owner;
@end
