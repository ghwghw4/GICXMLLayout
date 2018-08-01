//
//  NSObject+GICStyle.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/31.
//

#import "NSObject+GICStyle.h"
#import <objc/runtime.h>
#import "GICXMLLayoutPrivate.h"

@implementation NSObject (GICStyle)

-(void)setGic_style:(GICStyle *)gic_style{
    objc_setAssociatedObject(self, "gic_style", gic_style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(GICStyle *)gic_style{
    return objc_getAssociatedObject(self, "gic_style");
}

-(NSDictionary<NSString *,NSString *>*)gic_getStyleFromStyleName:(NSString *)styleName{
    NSDictionary<NSString *,NSString *>* styles = [self.gic_style  styleFromStyleName:styleName];
    if(styles){
        return styles;
    }
    NSObject *superElement= [self gic_getSuperElement];
    if(superElement){
        return [superElement gic_getStyleFromStyleName:styleName];
    }
    return nil;
}

-(NSDictionary<NSString *,NSString *>*)gic_getStyleFromElementName:(NSString *)elementName{
    NSDictionary<NSString *,NSString *>* styles = [self.gic_style  styleFromElementName:elementName];
    if(styles){
        return styles;
    }
    NSObject *superElement= [self gic_getSuperElement];
    if(superElement){
        return [superElement gic_getStyleFromElementName:elementName];
    }
    return nil;
}

-(NSMutableDictionary<NSString *, NSString *> *)gic_mergeStyles:(GDataXMLElement *)element{
    NSMutableDictionary<NSString *, NSString *> *attributeDict=[NSMutableDictionary dictionary];
    [element.attributes enumerateObjectsUsingBlock:^(GDataXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributeDict setValue:[obj stringValueOrginal] forKey:[obj name]];
    }];
    
    // 优先合并style样式
    NSString *styleName = [attributeDict objectForKey:@"style"];
    if(styleName){
        NSDictionary<NSString *,NSString *>* styles = [self gic_getStyleFromStyleName:styleName];
        for(NSString *key in styles){
            if(![attributeDict.allKeys containsObject:key]){
                [attributeDict setValue:styles[key] forKey:key];
            }
        }
    }
    
    if([GICXMLLayout enableDefualtStyle]){
        // 最后合并默认样式
        NSDictionary<NSString *,NSString *>* defualtStyles = [self gic_getStyleFromElementName:element.name];
        if(defualtStyles){
            for(NSString *key in defualtStyles){
                if(![attributeDict.allKeys containsObject:key]){
                    [attributeDict setValue:defualtStyles[key] forKey:key];
                }
            }
        }
    }
    //NOTE:以上样式的获取都是采用递归获取的。由于采用了树状递归，因此性能影响几乎可以忽略不计。在当前的CPU频率下，甚至都测不出来区别(已经测试过了)。因此不用担心性能问题
    return attributeDict;
}
@end
