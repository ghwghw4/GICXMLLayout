//
//  GICBoolConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICValueConverter.h"

@interface GICBoolConverter : GICValueConverter
-(NSNumber *)convert:(NSString *)xmlStringValue;
-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per;
@end
