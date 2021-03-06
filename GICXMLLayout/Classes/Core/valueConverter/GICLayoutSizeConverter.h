//
//  GICLayoutSizeConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import <Foundation/Foundation.h>
#import "GICAttributeValueConverter.h"

ASLayoutSize ASLayoutSizeMakeFromString(NSString *str);

@interface GICLayoutSizeConverter : GICAttributeValueConverter
-(NSValue *)convert:(NSString *)stringValue;
-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per;

-(NSString *)valueToString:(NSValue *)value;
@end
