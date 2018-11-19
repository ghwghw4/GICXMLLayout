//
//  JSValue+GICJSExtension.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/2.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue (GICJSExtension)
@property (readonly) BOOL gic_isArray;
-(JSManagedValue *)gic_ToManagedValue:(id)owner;

-(JSValue *)excuteJSString:(NSString *)jsString withArguments:(NSArray *)arguments;
@end
