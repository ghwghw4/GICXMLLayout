//
//  JSValue+GICJSExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/2.
//

#import "JSValue+GICJSExtension.h"
#import "GICJSCore.h"

@implementation JSValue (GICJSExtension)
-(BOOL)gic_isArray{
    if([self isUndefined])
        return false;
    return [[self invokeMethod:@"isArray" withArguments:nil] toBool];
}
-(JSManagedValue *)gic_ToManagedValue:(id)owner{
    if([self isNull] || [self isUndefined]){
        return nil;
    }
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

-(JSValue *)excuteJSString:(NSString *)jsString withArguments:(NSArray *)arguments{
    if(jsString){
        NSMutableArray *mutArray = [NSMutableArray array];
        [mutArray addObject:jsString];
        if(arguments && arguments.count>0)
            [mutArray addObjectsFromArray:arguments];
        return [self invokeMethod:@"executeScript" withArguments:mutArray];
    }
    return nil;
}

-(void)print{
    [self excuteJSString:@"console.log(JSON.stringify(this))" withArguments:nil];
}
@end
