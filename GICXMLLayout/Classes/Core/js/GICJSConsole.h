//
//  GICJSConsole.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/7.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol GICJSConsole <JSExport>
-(void)log:(JSValue *)value;
@end

@interface GICJSConsole : NSObject<GICJSConsole>
@end
