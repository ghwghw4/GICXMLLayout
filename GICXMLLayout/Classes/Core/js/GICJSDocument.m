//
//  GICJSDocument.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/18.
//

#import "GICJSDocument.h"
#import "GICElementsHelper.h"
#import "GICJSElementValue.h"

@implementation GICJSDocument
-(id)initRootElement:(id)root{
    self = [self init];
    self->rootElement = root;
    return self;
}

-(JSValue *)rootElement{
    return [GICJSElementValue getJSValueFrom:self->rootElement inContext:[JSContext currentContext]];
}

-(NSArray *)getElementsByName:(NSString *)name{
    NSArray *elments = [GICElementsHelper findSubElementsFromSuperElement:self->rootElement withName:name];
    if(elments.count>0){
        // 获取子元素后，需要将子元素转换成JSValue
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:elments.count];
        [elments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutArr addObject:[GICJSElementValue getJSValueFrom:obj inContext:[JSContext currentContext]]];
        }];
        return mutArr;
    }
    return @[];
}
@end
