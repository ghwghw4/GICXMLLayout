//
//  GICGridPanel.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/8.
//

#import <Foundation/Foundation.h>
#import "GICPanel.h"

@interface GICGridPanel : GICPanel
+(NSInteger)columnSpanFromElement:(id)element;
@end
