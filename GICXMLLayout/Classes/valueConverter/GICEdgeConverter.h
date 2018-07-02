//
//  GICEdgeConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICValueConverter.h"
#import <UIKit/UIKit.h>

/**
 边框转换
 */
@interface GICEdgeConverter : GICValueConverter
-(NSValue *)convert:(NSString *)xmlStringValue;
@end
