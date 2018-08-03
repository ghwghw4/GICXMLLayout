//
//  GICStyle.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/31.
//

#import <Foundation/Foundation.h>
/**
 样式的支持
 */
@interface GICStyle : NSObject{
    NSMutableDictionary<NSString *,NSDictionary<NSString *,NSString *>*> *styleForNamesDict;
    NSMutableDictionary<NSString *,NSDictionary<NSString *,NSString *>*> *styleForElementsDict;
}
@property (nonatomic,strong)NSString *path;
-(NSDictionary<NSString *,NSString *>*)styleFromStyleName:(NSString *)styleName;
-(NSDictionary<NSString *,NSString *>*)styleFromElementName:(NSString *)elementName;
@end
