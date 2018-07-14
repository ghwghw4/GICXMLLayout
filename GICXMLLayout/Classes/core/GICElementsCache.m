//
//  GICElementsCache.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/14.
//

#import "GICElementsCache.h"

@implementation GICElementsCache
static NSMutableDictionary<NSString *,Class> *registedElementsMap = nil;
+(void)initialize{
    registedElementsMap = [NSMutableDictionary dictionary];
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





/**
 attributs 缓存
 
 @return <#return value description#>
 */
+ (NSMutableDictionary<NSString *,NSDictionary<NSString *,GICValueConverter *> *> *)classAttributsCache {
    static NSMutableDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSMutableDictionary dictionary];
    });
    return _instance;
}


+(void)registClassAttributs:(Class)klass{
    if(!klass){
        return;
    }
    
    NSString *className = NSStringFromClass(klass);
    NSDictionary<NSString *,GICValueConverter *> *value = [self.classAttributsCache objectForKey:className];
    if (value) {//已经注册过了那么就忽略
        return;
    }
    
    // 先给父类注册
    Class superClass = class_getSuperclass(klass);
    [self registClassAttributs:class_getSuperclass(klass)];
    
    NSMutableDictionary<NSString *, GICValueConverter *> *dict = [NSMutableDictionary dictionary];
    // 先添加父类的属性，再添加子类的属性。这样保证子类的属性可以覆盖父类的属性
    if(superClass){
        [dict addEntriesFromDictionary:[self.classAttributsCache objectForKey:NSStringFromClass(superClass)]];
    }
    [dict addEntriesFromDictionary:[klass performSelector:@selector(gic_elementAttributs)]];
    // 保存到缓存中
    [self.classAttributsCache setValue:dict forKey:className];
}

+(BOOL)injectAttributes:(NSDictionary<NSString *,GICValueConverter *> *)attributs forElementName:(NSString *)elementName{
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

+(NSDictionary<NSString *, GICValueConverter *> *)classAttributs:(Class)klass{
    if(!klass){
        return nil;
    }
    NSString *className = NSStringFromClass(klass);
    if(![self.classAttributsCache.allKeys containsObject:className]){
        [self registClassAttributs:klass];
    }
    return [self.classAttributsCache objectForKey:className];
}


@end
