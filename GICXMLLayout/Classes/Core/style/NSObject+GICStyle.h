//
//  NSObject+GICStyle.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/31.
//

#import <Foundation/Foundation.h>
#import "GICStyle.h"

@interface NSObject (GICStyle)
@property (nonatomic,strong)GICStyle *gic_style;
//-(NSDictionary<NSString *,NSString *>*)gic_getStyleFromStyleName:(NSString *)styleName;
//-(GICStyle *)gic_getStyleFromElementName:(NSString *)elementName;
// 合并样式
-(NSMutableDictionary<NSString *, NSString *> *)gic_mergeStyles:(GDataXMLElement *)element;
@end
