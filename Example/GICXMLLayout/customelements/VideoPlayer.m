//
//  VideoPlayer.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/12/5.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "VideoPlayer.h"
#import <GICXMLLayout/GICStringConverter.h>

@implementation VideoPlayer
+(NSString *)gic_elementName{
    return @"video";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"url":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [((VideoPlayer *)target) setUrl:value];
                 });
             }],
             };
}

-(id)init{
    self = [super init];
    
    self.shouldAutoplay = YES; // 自动播放
    self.shouldAutorepeat = YES; // 循环播放
    self.muted = YES; //静音
    
    return self;
}

-(void)setUrl:(NSString *)url{
    _url = [url copy];
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:url]];
    self.asset = asset;
}
@end
