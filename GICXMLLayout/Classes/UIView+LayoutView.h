//
//  UIView+LayoutView.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>

@class GDataXMLElement;

@interface UIView (LayoutView)
+(NSString *)elementName;
-(void)parseElement:(GDataXMLElement *)element;

-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict;
@end
