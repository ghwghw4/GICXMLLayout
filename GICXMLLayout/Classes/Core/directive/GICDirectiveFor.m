//
//  GICDirectiveFor.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICDirectiveFor.h"
#import "NSObject+GICDataBinding.h"
#import "NSObject+GICDataContext.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "GICTemplateRef.h"

#define kGICDirectiveForElmentOrderStart  0.0001

@implementation GICDirectiveFor
+(NSString *)gic_elementName{
    return @"for";
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self->xmlDoc =  [[GDataXMLDocument alloc] initWithXMLString:children[0].XMLString options:0 error:nil];
    }
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(void)gic_updateDataContext:(id)superDataContenxt{
    [super gic_updateDataContext:superDataContenxt];
    [self updateDataSource:[self gic_DataContext]];
}

-(void)updateDataSource:(id)dataSource{
    //TODO: 对data-model的支持
    if([dataSource isKindOfClass:[NSArray class]] && [self.target respondsToSelector:@selector(gic_addSubElement:)]){
        [self.target gic_removeSubElements:[self.target gic_subElements]];//更新数据源以后需要清空原来是数据，然后重新添加数据
        for(id data in dataSource){
            [self addAElement:data];
        }
        if([dataSource isKindOfClass:[NSMutableArray class]]){
            // 监听添加对象事件
            @weakify(self)
            [[dataSource rac_signalForSelector:@selector(addObject:)] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(self)
                [self addAElement:x[0]];
            }];
            
            [[dataSource rac_signalForSelector:@selector(addObjectsFromArray:)] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(self)
                for(id data in x[0]){
                    [self addAElement:data];
                }
            }];
            
            // 监听删除对象事件
            [[dataSource rac_signalForSelector:@selector(removeObject:)] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(self)
                for(NSObject *obj in [self.target gic_subElements]){
                    if([[obj gic_self_dataContext] isEqual:x[0]]){
                        [self.target gic_removeSubElements:@[obj]];
                        break;
                    }
                }
            }];
            
            [[dataSource rac_signalForSelector:@selector(removeAllObjects)] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(self)
                [self.target gic_removeSubElements:[[self.target gic_subElements] copy]];
            }];
            
            [[dataSource rac_signalForSelector:@selector(removeObjectsInArray:)] subscribeNext:^(RACTuple * _Nullable x) {
                NSMutableArray *temp = [NSMutableArray array];
                @strongify(self)
                for(NSObject *obj in [self.target gic_subElements]){
                    if([(NSArray *)x[0] containsObject:[obj gic_self_dataContext]]){
                        [temp addObject:obj];
                    }
                }
                if(temp.count>0){
                    [self.target gic_removeSubElements:temp];
                }
            }];
        }
    }
}

-(void)addAElement:(id)data{
    NSObject *childElement = [NSObject gic_createElement:[self->xmlDoc rootElement] withSuperElement:self.target];
    childElement.gic_isAutoInheritDataModel = NO;
    childElement.gic_DataContext = data;
    childElement.gic_ExtensionProperties.elementOrder = self.gic_ExtensionProperties.elementOrder;
    [self.target gic_addSubElement:childElement];
}
@end
