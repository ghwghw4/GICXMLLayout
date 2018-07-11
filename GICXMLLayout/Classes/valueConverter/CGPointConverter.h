//
//  CGPointConverter.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import <GICXMLLayout/GICXMLLayout.h>
#import "GICValueConverter.h"
@interface CGPointConverter : GICValueConverter
-(NSValue *)convert:(NSString *)xmlStringValue;
@end
