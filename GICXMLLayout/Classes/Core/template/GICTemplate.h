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
@interface GICTemplate : NSObject{
    
}
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong,readonly)NSString *xmlDocString;


//#pragma mark 全局模板
//+(void)cacheTemplate:(GICTemplate *)t;
//+(GICTemplate *)templateForName:(NSString *)name;
@end
