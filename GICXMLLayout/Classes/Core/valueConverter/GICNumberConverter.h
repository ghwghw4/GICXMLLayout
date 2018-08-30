//
//  GICFloatConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "GICAttributeValueConverter.h"

@interface GICNumberConverter : GICAttributeValueConverter
-(NSNumber *)convert:(NSString *)stringValue;
-(NSNumber *)convertAnimationValue:(NSNumber *)from to:(NSNumber *)to per:(CGFloat)per;

-(NSString *)valueToString:(NSNumber *)value;
@end
