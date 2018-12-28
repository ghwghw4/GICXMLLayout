//
//  GICJSConsole.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import "GICJSConsole.h"

@implementation GICJSConsole
-(void)log:(JSValue *)value{
#if DEBUG
    if([value isNull] || [value isUndefined])
        return;
    NSString *content =[[value invokeMethod:@"toString" withArguments:nil] toString];
    NSLog(@"JSConsole:  %@",content);
#endif
}
@end

