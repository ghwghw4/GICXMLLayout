//
//  GICElementsCache.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/14.
//

#import "GICElementsCache.h"

@implementation GICElementsCache
// gloable elements
static NSMutableDictionary<NSString *,Class> *registedElementsMap = nil;
// behavior
static NSMutableDictionary<NSString *,Class> *registedBehaviorElementsMap = nil;
// 缓存的属性
static NSMutableDictionary<NSString *,NSDictionary<NSString *,GICAttributeValueConverter *> *> *classAttributsCache;

+(void)initialize{
    registedElementsMap = [NSMutableDictionary dictionary];
    registedBehaviorElementsMap = [NSMutableDictionary dictionary];
    classAttributsCache = [NSMutableDictionary dictionary];
}

+(void)registElement:(Class)elementClass{
    if(class_getClassMethod(elementClass, @selector(gic_elementName))){
        NSString *name = [elementClass performSelector:@selector(gic_elementName)];
        if(name && [name length]>0){
            [registedElementsMap setValue:elementClass forKey:name];
            // 同事缓存属性
            [self registClassAttributs:elementClass];
        }
    }
}

+(Class)classForElementName:(NSString *)elementName{
    return [registedElementsMap objectForKey:elementName];
}


+(void)registClassAttributs:(Class)klass{
    if(!klass){
        return;
    }
    
    NSString *className = NSStringFromClass(klass);
    if(!className){
        return;
    }
    NSDictionary<NSString *,GICAttributeValueConverter *> *value = [classAttributsCache objectForKey:className];
    if (value) {//已经注册过了那么就忽略
        return;
    }
    
    // 先给父类注册
    Class superClass = class_getSuperclass(klass);
    [self registClassAttributs:superClass];
    
    NSMutableDictionary<NSString *, GICAttributeValueConverter *> *dict = [NSMutableDictionary dictionary];
    // 先添加父类的属性，再添加子类的属性。这样保证子类的属性可以覆盖父类的属性
    if(superClass){
        [dict addEntriesFromDictionary:[classAttributsCache objectForKey:NSStringFromClass(superClass)]];
    }
    [dict addEntriesFromDictionary:[klass performSelector:@selector(gic_elementAttributs)]];
    // 保存到缓存中
    [classAttributsCache setValue:dict forKey:className];
}

+(BOOL)injectAttributes:(NSDictionary<NSString *,GICAttributeValueConverter *> *)attributs forElementName:(NSString *)elementName{
    Class klass = [self classForElementName:elementName];
    if(!klass)
        return NO;
    NSMutableDictionary  *dict = (NSMutableDictionary *)[self classAttributs:klass];
    if(!dict){
        return NO;
    }
    [dict addEntriesFromDictionary:attributs];
    return true;
}

+(NSDictionary<NSString *, GICAttributeValueConverter *> *)classAttributs:(Class)klass{
    if(!klass){
        return nil;
    }
    NSString *className = NSStringFromClass(klass);
    if(![classAttributsCache.allKeys containsObject:className]){
        [self registClassAttributs:klass];
    }
    return [classAttributsCache objectForKey:className];
}

+(void)registBehaviorElement:(Class)elementClass{
    if(![elementClass isSubclassOfClass:[GICBehavior class]]){
        NSAssert(false, @"注册的元素非behavior");
        return;
    }
    if(class_getClassMethod(elementClass, @selector(gic_elementName))){
        NSString *name = [elementClass performSelector:@selector(gic_elementName)];
        if(name && [name length]>0){
            [registedBehaviorElementsMap setValue:elementClass forKey:name];
            // 同事缓存属性
            [self registClassAttributs:elementClass];
        }
    }
}

+(Class)classForBehaviorElementName:(NSString *)elementName{
    return [registedBehaviorElementsMap objectForKey:elementName];
}
@end
