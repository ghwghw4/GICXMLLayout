//
//  GICXMLLayoutDevTools.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/29.
//

#import <Foundation/Foundation.h>


@interface GICXMLLayoutDevTools : NSObject
+(UIViewController *)loadXMLFromUrl:(NSURL *)url;

+(void)loadAPPFromPath:(NSString *)path;
@end
