//
//  GICFloatConverter.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "GICValueConverter.h"

@interface GICNumberConverter : GICValueConverter
-(NSNumber *)convert:(NSString *)xmlStringValue;
@end
