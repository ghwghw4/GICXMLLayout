//
//  GICDirectiveFor.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICDirective.h"
#define kGICDirectiveForElmentOrderStart  0.0001
/**
 for 指令.
 */
@interface GICDirectiveFor : GICDirective{
    GDataXMLDocument *xmlDoc;
}

-(void)removeAllItems;
@end
