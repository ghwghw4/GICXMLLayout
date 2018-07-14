//
//  GICColorConverter.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICColorConverter.h"
#import "UIColor+Extension.h"

@implementation GICColorConverter



-(UIColor *)convert:(NSString *)xmlStringValue{
    return [GICUtils colorConverter:xmlStringValue];
}

-(void)setProperty:(UIView *)view withXMLStringValue:(NSString *)xmlStringValue{
    [view setBackgroundColor:[self convert:xmlStringValue]];
}
@end
