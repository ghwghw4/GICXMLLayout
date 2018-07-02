//
//  GICFloatConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICFloatConverter.h"

@implementation GICFloatConverter
-(NSNumber *)convert:(NSString *)xmlStringValue{
    return @([xmlStringValue floatValue]);
}
@end
