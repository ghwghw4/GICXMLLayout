//
//  GICNSObjectExtensionProperties.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/10.
//

#import "GICNSObjectExtensionProperties.h"

@implementation GICNSObjectExtensionProperties
-(id)init{
    self = [super init];
    _dockHorizalModel = GICDockPanelHorizalModel_Center;
    _dockVerticalModel = GICDockPanelVerticalModel_Center;
    _subElements = [NSMutableArray array];
    return self;
}

-(void)addSubElement:(id)subElement{
    if(![(NSMutableArray *)self.subElements containsObject:subElement]){
        [(NSMutableArray *)self.subElements addObject:subElement];
    }
}

-(void)insertSubElement:(id)subElement atIndex:(NSInteger)index{
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
@end
