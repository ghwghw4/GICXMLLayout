//
//  GICURLConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICURLConverter.h"

@implementation GICURLConverter
-(NSURL *)convert:(NSString *)xmlStringValue{
    return [NSURL URLWithString:xmlStringValue];
}
@end
