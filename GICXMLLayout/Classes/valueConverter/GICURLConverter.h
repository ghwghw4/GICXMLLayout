//
//  GICURLConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICValueConverter.h"

@interface GICURLConverter : GICValueConverter
-(NSURL *)convert:(NSString *)xmlStringValue;
@end
