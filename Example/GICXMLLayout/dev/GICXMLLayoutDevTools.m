//
//  GICXMLLayoutDevTools.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/29.
//

#import "GICXMLLayoutDevTools.h"
#import "GICXMLLayoutDevPage.h"

@implementation GICXMLLayoutDevTools
+(GICXMLLayoutDevPage *)loadXMLFromUrl:(NSURL *)url{
    GICXMLLayoutDevPage *page =[[GICXMLLayoutDevPage alloc] initWithUrl:url];
    return page;
}
@end
