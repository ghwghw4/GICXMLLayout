//
//  NSObject+LayoutView.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import <Foundation/Foundation.h>
#import "GICNSObjectExtensionProperties.h"

@interface NSObject (LayoutElement)<LayoutElementProtocol>
@property (nonatomic,strong,readonly)GICNSObjectExtensionProperties *gic_ExtensionProperties;


-(void)gic_parseElement:(GDataXMLElement *)element;
-(void)gic_parseAttributes:(GDataXMLElement *)element;
@end
