//
//  GICTemplate.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>

/**
 核心组件，模板
 */
@interface GICTemplate : NSObject<LayoutElementProtocol>{
    GDataXMLDocument *xmlDoc;
}
@property (nonatomic,strong)NSString *name;

-(NSObject *)createElement;
@end
