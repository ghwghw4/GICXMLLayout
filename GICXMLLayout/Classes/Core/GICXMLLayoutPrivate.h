//
//  GICXMLLayoutPrivate.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/31.
//

#ifndef GICXMLLayoutPrivate_h
#define GICXMLLayoutPrivate_h
#import "GICXMLLayout.h"
@interface GICXMLLayout (Private)
+(BOOL)enableDefualtStyle;
+(NSData *)loadXmlDataFromPath:(NSString *)path;
+(NSData *)loadXmlDataFromUrl:(NSURL *)url;
@end

#endif /* GICXMLLayoutPrivate_h */
