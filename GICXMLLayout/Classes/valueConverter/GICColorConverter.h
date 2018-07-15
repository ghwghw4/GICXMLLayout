//
//  GICColorConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICValueConverter.h"

@interface GICColorConverter : GICValueConverter
-(UIColor *)convert:(NSString *)xmlStringValue;

-(UIColor *)convertAnimationValue:(UIColor *)from to:(UIColor *)to per:(CGFloat)per;
@end
