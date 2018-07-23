//
//  GICSizeConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//


#import "GICAttributeValueConverter.h"
@interface GICSizeConverter : GICAttributeValueConverter
-(NSValue *)convert:(NSString *)stringValue;
-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per;
@end
