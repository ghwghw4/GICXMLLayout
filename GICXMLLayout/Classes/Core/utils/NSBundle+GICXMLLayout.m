//
//  NSBundle+GICXMLLayout.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import "NSBundle+GICXMLLayout.h"

@implementation NSBundle (GICXMLLayout)
+ (instancetype)GICXMLLayoutBundle
{
    static NSBundle *XMLLayoutBundle = nil;
    if (XMLLayoutBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        XMLLayoutBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GICXMLLayout class]] pathForResource:@"GICXMLLayout" ofType:@"bundle"]];
    }
    return XMLLayoutBundle;
}

+(NSString *)gic_jsCoreString{
    NSData *data = [NSData dataWithContentsOfFile:[[self GICXMLLayoutBundle] pathForResource:@"JSCore" ofType:@"js"]];
    return [[NSString alloc] initWithData:data encoding:4];
}
@end
