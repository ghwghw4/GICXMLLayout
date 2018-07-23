//
//  GICEdgeConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICAttributeValueConverter.h"
#import <UIKit/UIKit.h>

/**
 边框转换
 */
@interface GICEdgeConverter : GICAttributeValueConverter
-(NSValue *)convert:(NSString *)stringValue;
-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per;
@end
