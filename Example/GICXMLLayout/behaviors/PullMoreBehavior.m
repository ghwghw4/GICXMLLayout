//
//  PullMoreBehavior.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/24.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "PullMoreBehavior.h"
#import "GICListView.h"
#import <MJRefresh/MJRefresh.h>
#import "GICStringConverter.h"
#import "GICBoolConverter.h"

@implementation PullMoreBehavior
+(NSString *)gic_elementName{
    return @"bev-pullmore";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"event-refresh":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 PullMoreBehavior *item = (PullMoreBehavior *)target;
                 item.refreshEvent = [[GICEvent alloc] initWithExpresion:value];
                 [item.refreshEvent attachTo:target];
             }],
             @"loading":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 PullMoreBehavior *item = (PullMoreBehavior *)target;
                 item.isLoading = [value boolValue];
             }],
             };
}

-(void)attachTo:(GICListView *)target{
    [super attachTo:target];
    if([target isKindOfClass:[GICListView class]]){
        // 必须在UI线程访问view
        dispatch_async(dispatch_get_main_queue(), ^{
            target.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
        });
    }
}

-(void)onRefresh{
    [self.refreshEvent fire:nil];
}

-(void)setIsLoading:(BOOL)isLoading{
    _isLoading = isLoading;
    if(isLoading){
        dispatch_async(dispatch_get_main_queue(), ^{
            MJRefreshFooter *header = ((GICListView *)self.target).view.mj_footer;
            if(!header.isRefreshing){
                [header beginRefreshing];
            }
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [((GICListView *)self.target).view.mj_footer endRefreshing];
        });
    }
}
@end
