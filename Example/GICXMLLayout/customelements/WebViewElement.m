//
//  WebViewElement.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/8/10.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "WebViewElement.h"
#import "GICURLConverter.h"

@implementation WebViewElement
+(NSString *)gic_elementName{
    return @"webview-page";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"url":[[GICURLConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(WebViewElement *)target setUrl:value];
             }],
             };
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.view addSubview:webView];
}
@end
