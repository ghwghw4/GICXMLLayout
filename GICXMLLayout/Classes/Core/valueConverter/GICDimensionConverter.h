//
//  GICDimensionConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICAttributeValueConverter.h"
@interface GICDimensionConverter : GICAttributeValueConverter
-(NSValue *)convert:(NSString *)stringValue;
-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per;
+(ASDimension)convertAnimationValue:(ASDimension)from to:(ASDimension)to per:(CGFloat)per;
@end
