//
//  GICXMLLayoutDevTools.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/29.
//

#import "GICXMLLayoutDevTools.h"
#import "GICXMLLayoutDevPage.h"
#import "GICRouter.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation GICXMLLayoutDevTools
+(GICXMLLayoutDevPage *)loadXMLFromUrl:(NSURL *)url{
    GICXMLLayoutDevPage *page =[[GICXMLLayoutDevPage alloc] initWithUrl:url];
    return page;
}

+(void)loadPage:(NSString *)path{
    [GICRouter loadAPPFromPath:path];
    UIWindow *w = [UIApplication sharedApplication].delegate.window;
    UIButton *btnReload = [[UIButton alloc] initWithFrame:CGRectMake(w.bounds.size.width-60 -15, w.bounds.size.height-44-40, 60, 44)];
    [btnReload setTitle:@"reload" forState:UIControlStateNormal];
    [btnReload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnReload.layer.borderColor = [UIColor blackColor].CGColor;
    btnReload.layer.borderWidth = 1;
    [w addSubview:btnReload];
    [[btnReload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [btnReload removeFromSuperview];
        [self loadAPPFromPath:path];
    }];
    
    
    
//    NSMutableURLRequest *mutRerequest=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
//    mutRerequest.HTTPMethod = @"GET";
//    [[[NSURLSession sharedSession] dataTaskWithRequest:mutRerequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSInteger code = [httpResponse statusCode];
//        if(code==200){
//            @try {
//                [GICRouter loadAPP:data withParseCompelete:^(UIViewController *rootPage) {
//                    UIWindow *w = [UIApplication sharedApplication].delegate.window;
//                    UIButton *btnReload = [[UIButton alloc] initWithFrame:CGRectMake(w.bounds.size.width-60 -15, w.bounds.size.height-44-40, 60, 44)];
//                    [btnReload setTitle:@"reload" forState:UIControlStateNormal];
//                    [btnReload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    btnReload.layer.borderColor = [UIColor blackColor].CGColor;
//                    btnReload.layer.borderWidth = 1;
//                    [w addSubview:btnReload];
//                    [[btnReload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//                        [btnReload removeFromSuperview];
//                        [self loadAPPFromUrl:url];
//                    }];
//                }];
//            } @catch (NSException *exception) {
//                NSLog(@"%@",exception);
//            }
//
//        }else{
//
//        }
//    }] resume];
}

+(void)loadAPPFromPath:(NSString *)path{
    [self loadPage:path];
   
}
@end
