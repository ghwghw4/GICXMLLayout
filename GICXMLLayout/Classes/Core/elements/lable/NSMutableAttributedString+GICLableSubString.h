//
//  NSMutableAttributedString+GICLableSubString.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (GICLableSubString)
-(id)initWithXmlElement:(GDataXMLElement *)xmlElement;
@property (nonatomic,strong)NSMutableDictionary *gic_attributDict;
@property (nonatomic,assign,readonly)BOOL gic_isImg;
@property (nonatomic,readonly)NSURL *gic_linkUrl;
@end
