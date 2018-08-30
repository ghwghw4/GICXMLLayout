//
//  GICURLConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICAttributeValueConverter.h"

@interface GICURLConverter : GICAttributeValueConverter
-(NSURL *)convert:(NSString *)stringValue;
-(NSString *)valueToString:(NSURL *)value;
@end
