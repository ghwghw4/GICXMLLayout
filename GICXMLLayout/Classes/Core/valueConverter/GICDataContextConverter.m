//
//  GICDataContextConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICDataContextConverter.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation GICDataContextConverter
-(id)convert:(NSString *)stringValue{
    id obj = [NSJSONSerialization JSONObjectWithData:[stringValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if(obj){
        return obj;
    }
    
//    JSContext *context = [[JSContext alloc] init];
//    context[@"data"] = xmlStringValue;
//    
//    JSValue *v = context[@"data"];
//    NSDictionary *dict =  [v toDictionary];
//    NSLog(@"%@",dict);
    
    Class class = NSClassFromString(stringValue);
    if(class){
        return [class new];
    }
    return stringValue;
}
@end
