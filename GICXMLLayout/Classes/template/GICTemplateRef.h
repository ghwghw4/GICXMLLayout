//
//  GICTemplateRef.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>
#import "GICTemplate.h"

@interface GICTemplateRef : NSObject<LayoutElementProtocol>
@property (nonatomic,strong)NSString *templateName;
-(NSObject *)parseTemplate:(GICTemplate *)t;
@end
