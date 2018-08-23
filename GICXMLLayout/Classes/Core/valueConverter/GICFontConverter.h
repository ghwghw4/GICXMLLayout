//
//  GICFontConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/22.
//

#import <Foundation/Foundation.h>
#import "GICAttributeValueConverter.h"

@interface GICFontConverter : GICAttributeValueConverter
-(UIFont *)convert:(NSString *)stringValue;
@end
