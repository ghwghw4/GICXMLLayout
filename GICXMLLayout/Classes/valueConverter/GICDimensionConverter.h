//
//  GICDimensionConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICAttributeValueConverter.h"
@interface GICDimensionConverter : GICAttributeValueConverter
-(NSString *)convert:(NSString *)stringValue;
-(NSString *)convertAnimationValue:(NSString *)from to:(NSString *)to per:(CGFloat)per;
@end
