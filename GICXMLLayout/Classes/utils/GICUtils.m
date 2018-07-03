//
//  GICUtils.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICUtils.h"

@implementation GICUtils
+(CGFloat)numberConverter:(NSString *)stringValue{
//    if([stringValue.lowercaseString isEqualToString:@"auto"]){
//        return NumberAuto;
//    }
    return [stringValue floatValue];
}
@end
