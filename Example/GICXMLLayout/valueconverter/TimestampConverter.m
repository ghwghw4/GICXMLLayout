//
//  TimestampConverter.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "TimestampConverter.h"

@implementation TimestampConverter
-(id)convert:(NSString *)stringValue{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[stringValue doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
@end
