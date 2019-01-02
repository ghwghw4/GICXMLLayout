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
static NSMutableDictionary<NSString *,NSDictionary<NSString *,GICAttributeValueConverter *> *> *_classAttributsCache;
// 缓存的附加属性
static NSMutableDictionary<NSString *,NSDictionary<NSString *,GICAttributeValueConverter *> *> *_classAttachAttributsCache;

static dispatch_queue_t attributsReadWriteQueue;

+(void)initialize{
    registedElementsMap = [NSMutableDictionary dictionary];
    registedBehaviorElementsMap = [NSMutableDictionary dictionary];
    _classAttributsCache = [NSMutableDictionary dictionary];
    _classAttachAttributsCache = [NSMutableDictionary dictionary];
    attributsReadWriteQueue = dispatch_queue_create("GICXMLLayoutRegisetElementQueue", DISPATCH_QUEUE_CONCURRENT);
    
}

+(void)registElement:(Class)elementClass{
    if(class_getClassMethod(elementClass, @selector(gic_elementName))){
        NSString *name = [elementClass performSelector:@selector(gic_elementName)];
        if(name && [name length]>0){
            if([registedElementsMap.allKeys containsObject:name]){
                NSAssert(NO, @"存在相同名称的元素");
            }
            [registedElementsMap setValue:elementClass forKey:name];
            // 同事缓存属性
            [self registClassAttributs:elementClass];
        }
    }
}

+(Class)classForElementName:(NSString *)elementName{
    return [registedElementsMap objectForKey:elementName];
}

+(id)getAtttributesWithClassName:(NSString *)className{
    __block id value;
    dispatch_sync(attributsReadWriteQueue, ^{
        value = [_classAttributsCache objectForKey:className];
    });
    return value;
}

+(void)registClassAttributs:(Class)klass{
    if(!klass){
        return;
    }
    
    NSString *className = NSStringFromClass(klass);
    if(!className){
        return;
    }
    NSDictionary<NSString *,GICAttributeValueConverter *> *value = [self getAtttributesWithClassName:className];
    if (value) {//已经注册过了那么就忽略
        return;
    }
    
    // 先给父类注册
    Class superClass = class_getSuperclass(klass);
    [self registClassAttributs:superClass];
    
    NSMutableDictionary<NSString *, GICAttributeValueConverter *> *dict = [NSMutableDictionary dictionary];
    // 先添加父类的属性，再添加子类的属性。这样保证子类的属性可以覆盖父类的属性
    if(superClass){
        [dict addEntriesFromDictionary:[self getAtttributesWithClassName:NSStringFromClass(superClass)]];
    }
    
    [[klass performSelector:@selector(gic_elementAttributs)] enumerateKeysAndObjectsUsingBlock:^(NSString *key, GICAttributeValueConverter *obj, BOOL * _Nonnull stop) {
        obj.name = key;
        [dict setObject:obj forKey:key];
    }];
    
    // 缓存附加属性
    {
        NSMutableDictionary<NSString *, GICAttributeValueConverter *> *attachedDict = [NSMutableDictionary dictionary];
        if(superClass){
            NSDictionary * superAtts = [_classAttachAttributsCache objectForKey:NSStringFromClass(superClass)];
            [attachedDict addEntriesFromDictionary:superAtts];
        }
        [[klass performSelector:@selector(gic_elementAttachAttributs)] enumerateKeysAndObjectsUsingBlock:^(NSString *key, GICAttributeValueConverter *obj, BOOL * _Nonnull stop) {
            obj.name = key;
            [attachedDict setObject:obj forKey:key];
        }];
        if(attachedDict.count>0){
           [_classAttachAttributsCache setValue:attachedDict forKey:className];
        }
    }
    
    // 保存到缓存中
    dispatch_barrier_async(attributsReadWriteQueue, ^{
          [_classAttributsCache setValue:dict forKey:className];
    });
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
    NSDictionary<NSString *,GICAttributeValueConverter *> *value = [self getAtttributesWithClassName:className];
    if(!value){
        [self registClassAttributs:klass];
        value = [self getAtttributesWithClassName:className];
    }
    return value;
}

+(NSDictionary<NSString *, GICAttributeValueConverter *> *)classAttachAttributs:(Class)klass{
    if(!klass){
        return nil;
    }
    NSString *className = NSStringFromClass(klass);
    return [_classAttachAttributsCache objectForKey:className];
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
