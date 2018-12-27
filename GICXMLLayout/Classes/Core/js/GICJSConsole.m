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
    NSString *content =[[value invokeMethod:@"toJsonString" withArguments:nil] toString];
    NSLog(@"JSConsole:  %@",content);
#endif
}
@end

