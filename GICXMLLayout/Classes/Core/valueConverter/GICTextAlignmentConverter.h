//
//  GICTextAlignmentConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICAttributeValueConverter.h"

@interface GICTextAlignmentConverter : GICAttributeValueConverter
-(NSNumber *)convert:(NSString *)stringValue;
-(NSString *)valueToString:(NSNumber *)value;
@end
