//
//  GICDimensionConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICValueConverter.h"
@interface GICDimensionConverter : GICValueConverter
-(NSString *)convert:(NSString *)xmlStringValue;
-(NSString *)convertAnimationValue:(NSString *)from to:(NSString *)to per:(CGFloat)per;
@end
