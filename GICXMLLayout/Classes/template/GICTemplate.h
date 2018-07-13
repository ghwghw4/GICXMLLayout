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


//-(NSObject *)createElement;

//-(NSObject *)createElementWithSlotsMap:(NSMutableDictionary<NSString *, GDataXMLDocument *> *)slotMap;

//NSMutableDictionary<NSString *, GDataXMLDocument *> *
@end
