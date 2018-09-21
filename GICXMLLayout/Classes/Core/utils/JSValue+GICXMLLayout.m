//
//  JSValue+GICXMLLayout.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/17.
//

#import "JSValue+GICXMLLayout.h"

@implementation JSValue (GICXMLLayout)
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
