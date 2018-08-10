//
//  ToutiaoDetailViewModel.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/8/10.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "ToutiaoDetailViewModel.h"

@implementation ToutiaoDetailViewModel

- (void)navigationWithParams:(GICRouterParams *)params {
    self.urlString = [[params data] objectForKey:@"url"];
}

@end
