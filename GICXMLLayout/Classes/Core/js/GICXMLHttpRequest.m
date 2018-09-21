//
//  GICXMLHttpRequest.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import "GICXMLHttpRequest.h"

@implementation GICXMLHttpRequest {
    NSString* _method;
    NSString* _url;
    NSMutableDictionary* _headers;
    BOOL _async;
//    JSManagedValue* _onLoad;
//    JSManagedValue* _onReadyStateChange;
//    JSManagedValue* _onError;
}

@synthesize responseText;
@synthesize readyState;
@synthesize status;

-(void)open:(NSString*)httpMethod :(NSString*)url :(bool)async;
{
    _method = httpMethod;
    _url = url;
    _async = async;
    readyState = XMLHttpRequestOPENED;
}

-(void)setRequestHeader:(NSString *)key :(NSString *)value
{
    _headers[key] = value;
}

//-(void)setOnload:(JSValue *)onload
//{
//    _onLoad = [JSManagedValue managedValueWithValue:onload];
//    [[[JSContext currentContext] virtualMachine] addManagedReference:_onLoad withOwner:self];
//}
//
//-(JSValue*)onload { return _onLoad.value; }

//-(void)setOnreadystatechange:(JSValue *)onReadyStateChange
//{
//    _onReadyStateChange = [JSManagedValue managedValueWithValue:onReadyStateChange];
//    [[[JSContext currentContext] virtualMachine] addManagedReference:_onReadyStateChange withOwner:self];
//}
//
//-(JSValue*)onreadystatechange { return _onReadyStateChange.value; }


//-(void)setOnerror:(JSValue *)onerror
//{
//    _onError = [JSManagedValue managedValueWithValue:onerror];
//    [[[JSContext currentContext] virtualMachine] addManagedReference:_onError withOwner:self];
//}
//-(JSValue*)onerror { return _onError.value; }

-(void)send
{
    readyState = XMLHttpRequestHEADERS;
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    req.HTTPMethod = _method;
    
    for (NSString *items in _headers.allKeys) {
        [req setValue:_headers[items] forHTTPHeaderField:items];
    }
    readyState = XMLHttpRequestLOADING;
    
    JSValue *thisValue = [JSContext currentThis];
   
     void (^completionHandler)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) = ^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable error) {
        self.responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self->status = [(NSHTTPURLResponse *)response statusCode];
        self->readyState = XMLHttpRequestDONE;
        if (!error) {
            JSValue* _onLoad = thisValue[@"onload"];
            if([_onLoad isUndefined]){
                [thisValue[@"onreadystatechange"] callWithArguments:nil];
            }else{
                [_onLoad callWithArguments:nil];
            }
        } else if (error){
            JSValue* _onError = thisValue[@"onerror"];
            if(![_onError isUndefined]){
                [_onError callWithArguments:@[[JSValue valueWithNewErrorFromMessage:error.localizedDescription inContext:[JSContext currentContext]]]];
            }
        }
    };
    
    if(_async){//异步执行
        [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:completionHandler];
    }else{//同步执行
        NSHTTPURLResponse* response;
        NSError* error;
        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        completionHandler(response,data,error);
    }
}

}
@end
