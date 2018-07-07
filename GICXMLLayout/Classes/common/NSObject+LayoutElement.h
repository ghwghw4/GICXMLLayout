//
//  NSObject+LayoutView.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import <Foundation/Foundation.h>

@interface NSObject (LayoutElement)<LayoutElementProtocol>
-(void)parseElement:(GDataXMLElement *)element;
-(void)parseAttributes:(NSDictionary<NSString *, NSString *> *)attributeDict;
@end
