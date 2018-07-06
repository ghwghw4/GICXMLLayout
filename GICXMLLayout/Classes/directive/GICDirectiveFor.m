//
//  GICDirectiveFor.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICDirectiveFor.h"
#import "NSObject+GICDataBinding.h"
#import "NSObject+GICDataContext.h"

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
            id childElement = [GICXMLLayout createElement:self.templateElement];
            ((NSObject *)childElement).gic_isAutoInheritDataModel = NO;
            ((NSObject *)childElement).gic_DataContenxt = data;
            [self.target gic_addSubElement:childElement];
        }
    }
}
@end
