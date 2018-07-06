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

@implementation GICDirectiveFor
+(NSString *)gic_elementName{
    return @"for";
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    NSAssert(children.count <= 1, @"for 指令只支持单个子元素");
    if(children.count==1){
       self.templateElement = children[0];
    }
}

-(void)updateDataSource:(id)dataSource{
    if([dataSource isKindOfClass:[NSArray class]] && [self.target respondsToSelector:@selector(gic_addSubElement:)]){
        for(id data in dataSource){
            [self addAElement:data];
        }
        if([dataSource isKindOfClass:[NSMutableArray class]]){
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
        }
    }
}

-(void)addAElement:(id)data{
    NSObject *childElement = [GICXMLLayout createElement:self.templateElement];
    childElement.gic_isAutoInheritDataModel = NO;
    childElement.gic_DataContenxt = data;
    [self.target gic_addSubElement:childElement];
}
@end
