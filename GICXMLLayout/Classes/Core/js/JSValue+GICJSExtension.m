//
//  JSValue+GICJSExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/2.
//

#import "JSValue+GICJSExtension.h"
#import "GICJSCore.h"

@implementation JSValue (GICJSExtension)
-(JSManagedValue *)gic_ToManagedValue:(id)owner{
    //    if(owner){
    //        return [JSManagedValue managedValueWithValue:self andOwner:owner];
    //    }
    return [JSManagedValue managedValueWithValue:self];
    //
    
    //    JSManagedValue *mv = [JSManagedValue managedValueWithValue:self];
    //    if(owner){
    //         [[[JSContext currentContext] virtualMachine] addManagedReference:mv withOwner:owner];
    //    }
    //    return mv;
}
@end
