//
//  GICEventInfo.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICEventInfo.h"

@implementation GICEventInfo
-(id)initWithTarget:(id)target withValue:(id)value{
    self = [self init];
    _target = target;
    self.value = value;
    return self;
}
@end
