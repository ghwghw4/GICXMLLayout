//
//  GICColorConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICAttributeValueConverter.h"

@interface GICColorConverter : GICAttributeValueConverter
-(UIColor *)convert:(NSString *)stringValue;

-(UIColor *)convertAnimationValue:(UIColor *)from to:(UIColor *)to per:(CGFloat)per;
@end
