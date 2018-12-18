//
//  GICJSDocument.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/18.
//

#import "GICJSDocument.h"
#import "GICElementsHelper.h"
#import "JSValue+GICJSExtension.h"
#import "GICJSElementDelegate.h"
#import "JSContext+GICJSContext.h"
#import "GICTemplateRef.h"

@implementation GICJSDocument
//-(id)initRootElement:(id)root{
//    self = [self init];
//    self->rootElement = root;
//    return self;
//}

-(id)rootElement{
    return [[JSContext currentContext] rootElement];
}

+(id)rootElementFromJsContext:(JSContext *)jscontext{
    if(jscontext)
        return [jscontext rootElement].element;
    else
        return [[JSContext currentContext] rootElement].element;
}


-(NSArray *)getElementsByName:(NSString *)name{
    NSArray *elments = [GICElementsHelper findSubElementsFromSuperElement:[GICJSDocument rootElementFromJsContext:nil] withName:name];
    if(elments.count>0){
        // 获取子元素后，需要将子元素转换成JSValue
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:elments.count];
        [elments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutArr addObject:[GICJSElementDelegate getJSValueFrom:obj inContext:[JSContext currentContext]]];
        }];
        return mutArr;
    }
    return @[];
}

//-(JSValue *)createElementFromTemplate:(NSString *)templateName{
//    id root = [GICJSDocument rootElementFromJsContext:[JSContext currentContext]];
//    GICTemplateRef *ref = [[GICTemplateRef alloc] initWithTemplateName:templateName];
//    id node =[ref parseTemplateFromTarget:root];
//    return [GICJSElementDelegate getJSValueFrom:node inContext:[JSContext currentContext]];
//}

-(id)createElement:(NSString *)elmentName{
    Class c = [GICElementsCache classForElementName:elmentName];
    if(c){
        // TODO:这里面的元素会被立即释放掉，因为没有被添加到父元素中，而JS的引用又不会对元素强引用
        NSObject *v = [c createElementWithXML:nil];
        return [GICJSElementDelegate getJSValueFrom:v inContext:[JSContext currentContext]];
    }
    return nil;
}

+(UIView *)rootViewFromJSContenxt:(JSContext *)jscontext{
    __block UIView *rootView = nil;
    GICPerformBlockOnMainQueueSync(^{
       id root = [GICJSDocument rootElementFromJsContext:jscontext];
        if([root isKindOfClass:[UIViewController class]]){
            rootView = [(UIViewController *)root view];
        }else if ([root isKindOfClass:[ASDisplayNode class]]){
            rootView = [(ASDisplayNode *)root view];
        }
    });
    return rootView;
}
@end

