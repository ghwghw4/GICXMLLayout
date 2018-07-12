//
//  GICBehaviors.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/12.
//

#import "GICBehaviors.h"

@implementation GICBehaviors
+(NSString *)gic_elementName{
    return @"behaviors";
}
-(id)init{
    self = [super init];
    _behaviors = [NSMutableArray array];
    return self;
}
@end
