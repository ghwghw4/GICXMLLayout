//
//  GICTemplateRef.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>
#import "GICTemplate.h"

/**
 模板引用。支持slot
 slot 的使用可能会引起性能问题，主要是在for循环或者 list中使用的时候。因为会重复执行文本解析
 */
@interface GICTemplateRef : NSObject<LayoutElementProtocol>{
    NSMutableDictionary<NSString *, NSString *> *slotsXmlDocMap;
    
    NSMutableDictionary<NSString *,NSString *> *tempConvertSlotMap;
}
@property (nonatomic,strong)NSString *templateName;
-(NSObject *)parseTemplate:(GICTemplate *)t;

-(NSObject *)parseTemplateFromTarget:(id)target;
@end
