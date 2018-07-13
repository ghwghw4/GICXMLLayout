//
//  GICTemplates.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>
#import "GICTemplate.h"

/**
 模板数组
 */
@interface GICTemplates : NSObject{

}
@property (nonatomic,readonly)NSMutableDictionary<NSString *, GICTemplate *> *templats;
@end
