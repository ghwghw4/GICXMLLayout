//
//  GICXMLHttpRequest.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/6.
//

#import "GICXMLHttpRequest.h"
#import "JSValue+GICJSExtension.h"

@implementation GICXMLHttpRequest {
    BOOL _async;
    JSManagedValue* _onLoad;
    JSManagedValue* _onReadyStateChange;
    JSManagedValue* _onError;
    
    NSMutableURLRequest* request;
    
    NSURLSessionDataTask *dataTask;
    NSData *responseData;
}

@synthesize readyState;
@synthesize status;

-(id)init{
    self = [super init];
    request = [[NSMutableURLRequest alloc] init];
    return self;
}


-(void)setTimeout:(NSInteger)timeout{
    [request setTimeoutInterval:timeout];
}

-(NSInteger)timeout{
    return request.timeoutInterval;
}


-(void)open:(NSString*)httpMethod :(NSString*)url :(bool)async;
{
    request.HTTPMethod = httpMethod;
    [request setURL:[NSURL URLWithString:url]];
    _async = async;
    readyState = XMLHttpRequestOPENED;
}

-(void)setRequestHeader:(NSString *)key :(NSString *)value
{
    [request setValue:value forHTTPHeaderField:key];
}

-(void)setOnload:(JSValue *)onload
{
    _onLoad = [onload gic_ToManagedValue:self];
}

-(JSValue*)onload { return _onLoad.value; }

-(void)setOnreadystatechange:(JSValue *)onReadyStateChange
{
    _onReadyStateChange =[onReadyStateChange gic_ToManagedValue:self];
}

-(JSValue*)onreadystatechange { return _onReadyStateChange.value; }


-(void)setOnerror:(JSValue *)onerror
{
    _onError = [onerror gic_ToManagedValue:self];
}
-(JSValue*)onerror { return _onError.value; }

-(NSString *)responseText{
    if(responseData)
        return [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return nil;
}

-(void)send:(JSValue *)content
{
    readyState = XMLHttpRequestHEADERS;
    if(![content isNull] && ![content isUndefined]){
        [request setHTTPBody:[[content toString] dataUsingEncoding:4]];
    }
    readyState = XMLHttpRequestLOADING;
    if(_async){
        dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            self->responseData = data;
            self->status = [(NSHTTPURLResponse *)response statusCode];
            ASPerformBlockOnMainThread(^{
                [self requestCompletionWithError:error];
            });
        }];
        [dataTask resume];
    }else{
        NSHTTPURLResponse* response;
        NSError* error;
        self->responseData = [NSURLConnection sendSynchronousRequest:self->request returningResponse:&response error:&error];
        self->status = [(NSHTTPURLResponse *)response statusCode];
        [self requestCompletionWithError:error];
    }
}

-(void)requestCompletionWithError:(NSError* _Nullable) error{
    self->readyState = XMLHttpRequestDONE;
    if (error) {
        if(self.onerror){
            [self.onerror callWithArguments:@[[JSValue valueWithNewErrorFromMessage:error.localizedDescription inContext:[self.onerror context]]]];
        }
    } else {
        if(self.onload){
            [self.onload callWithArguments:nil];
        }else{
            [self.onreadystatechange callWithArguments:nil];
        }
    }
}

-(void)abort{
    [dataTask cancel];
}

-(void)dealloc{
    NSLog(@"GICXMLHttpRequest dealoc");
}
@end
