//
//  JSValue+GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/17.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue (GICXMLLayout)
-(JSManagedValue *)gic_ToManagedValue:(id)owner;
@end
