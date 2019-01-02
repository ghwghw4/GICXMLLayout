//
//  GICNSObjectExtensionProperties.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/10.
//

#import "GICNSObjectExtensionProperties.h"

@implementation GICNSObjectExtensionProperties{
    NSMutableDictionary *attachedProerties;
}
-(id)init{
    self = [super init];
    _subElements = [NSMutableArray array];
    attachedProerties = [NSMutableDictionary dictionary];
    return self;
}

-(void)addSubElement:(id)subElement{
    if(![(NSMutableArray *)self.subElements containsObject:subElement]){
        [(NSMutableArray *)self.subElements addObject:subElement];
    }
}

-(void)insertSubElement:(id)subElement atIndex:(NSInteger)index{
    if([self.subElements containsObject:subElement]){
        [(NSMutableArray *)self.subElements removeObject:subElement];
    }
    [(NSMutableArray *)self.subElements insertObject:subElement atIndex:index];
}

-(NSInteger)indexOfSubElement:(id)subElement{
    if([self.subElements containsObject:subElement]){
        return  [self.subElements indexOfObject:subElement];
    }
    return -1;
}

-(void)removeSubElements:(NSArray *)subElments{
    NSMutableArray *temp = (NSMutableArray *)self.subElements;
    [temp removeObjectsInArray:subElments];
}

-(void)removeAllSubElements{
     [(NSMutableArray *)self.subElements removeAllObjects];
}

-(void)setAttachValue:(id)value withAttributeName:(NSString *)attName{
    if(value){
        // 附加属性只能设置一次属性。
        if([attachedProerties.allKeys containsObject:attName]){
            return;
        }
        [attachedProerties setObject:value forKey:attName];
    }
}

-(id)attachValueWithAttributeName:(NSString *)attName{
    return [attachedProerties objectForKey:attName];
}
@end
