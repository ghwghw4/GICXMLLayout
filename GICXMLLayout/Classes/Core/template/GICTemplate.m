//
//  GICTemplate.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICTemplate.h"
#import "GICStringConverter.h"

@implementation GICTemplate
//#pragma mark 全局模板
//// 全局模板缓存
//static NSMutableDictionary<NSString *,GICTemplate *> *globalTemplatsCache = nil;
//+(void)initialize{
//    globalTemplatsCache = [NSMutableDictionary dictionary];
//}
//
//+(void)cacheTemplate:(GICTemplate *)t{
//    if(t && t.name){
//        [globalTemplatsCache setValue:t forKey:t.name];
//    }
//}
//
//+(GICTemplate *)templateForName:(NSString *)name{
//    return [globalTemplatsCache objectForKey:name];
//}

+(NSString *)gic_elementName{
    return @"template";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"t-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICTemplate *)target setName:value];
             }]
             };;
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self->_xmlDocString = [children[0] XMLString];
    }
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

@end
