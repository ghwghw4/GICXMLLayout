////
////  UIView+LayoutView.m
////  GDataXMLNode_GIC
////
////  Created by 龚海伟 on 2018/7/2.
////
//
//#import "UIView+LayoutView.h"
//#import "GDataXMLNode.h"
//#import <GDataXMLNode_GIC/GDataXMLNode.h>
//#import "UIColor+Extension.h"
//
//@implementation UIView (LayoutView)
//+(NSString *)elementName{
//    return @"view";
//}
//
//-(void)parseElement:(GDataXMLElement *)element{
//    [self parseAttributes:[self convertAttributes:element.attributes]];
//    for(GDataXMLElement *child in element.children){
////        UIView *childView =[Template createElement:child];
////        [self addSubview:childView];
//    }
//}
//
//-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
//    for(NSString *key in attributeDict.allKeys){
//        if([key isEqualToString:@"background-color"]){
//            [self parseBackgroundColor:[attributeDict objectForKey:key]];
//        }
//    }
//}
//
//-(void)parseBackgroundColor:(NSString *)colorString{
//    self.backgroundColor = [UIColor colorWithHexString:colorString];
//}
//
//-(NSDictionary *)convertAttributes:(NSArray<GDataXMLNode *> *)atts{
//    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
//    [atts enumerateObjectsUsingBlock:^(GDataXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [dict setValue:[obj stringValue] forKey:[obj name]];
//    }];
//    return dict;
//}
//@end
