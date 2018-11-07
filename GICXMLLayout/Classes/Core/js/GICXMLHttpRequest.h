//
//  GICXMLHttpRequest.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


typedef NS_ENUM(NSUInteger , ReadyState) {
    XMLHttpRequestUNSENT =0,    // open()has not been called yet.
    XMLHttpRequestOPENED,        // send()has not been called yet.
    XMLHttpRequestHEADERS,      // RECEIVED    send() has been called, and headers and status are available.
    XMLHttpRequestLOADING,      // Downloading; responseText holds partial data.
    XMLHttpRequestDONE          // The operation is complete.
};
@protocol GICXMLHttpRequest <JSExport>
@property NSString* responseText;
//@property JSValue* onload;
//@property JSValue* onreadystatechange;
//@property JSValue* onerror;
@property ReadyState readyState;
@property NSInteger status;

-(instancetype)init;

-(void)open:(NSString*)httpMethod :(NSString*)url :(bool)async;
-(void)send:(JSValue *)content;
-(void)setRequestHeader:(NSString*)key :(NSString*)value;

@end


@interface GICXMLHttpRequest :  NSObject <GICXMLHttpRequest>
@end
