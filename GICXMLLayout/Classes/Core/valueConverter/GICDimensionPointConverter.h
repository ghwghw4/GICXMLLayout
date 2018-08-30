//
//  GICDimensionPointConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import "GICAttributeValueConverter.h"

ASDimensionPoint ASDimensionPointMakeFromString(NSString *str);

@interface GICDimensionPointConverter : GICAttributeValueConverter
-(NSValue *)convert:(NSString *)stringValue;
-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per;

-(NSString *)valueToString:(NSValue *)value;
@end
