//
//  GICBoolConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICAttributeValueConverter.h"

@interface GICBoolConverter : GICAttributeValueConverter
-(NSNumber *)convert:(NSString *)stringValue;
-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per;

-(NSString *)valueToString:(NSNumber *)value;
@end
