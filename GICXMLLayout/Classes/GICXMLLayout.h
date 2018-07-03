//
//  GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GICXMLLayout : NSObject
+(void)regiterAllElements;

//+(Class)classFromElementName:(NSString *)elementName;

+(UIView *)createElement:(GDataXMLElement *)element;


+(UIView *)parseLayout:(NSData *)xmlData toView:(UIView *)superView;
@end
