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
    [(NSMutableArray *)self.subElements addObject:subElement];
}

-(void)removeSubElements:(NSArray *)subElments{
    NSMutableArray *temp = (NSMutableArray *)self.subElements;
    [temp removeObjectsInArray:subElments];
}

-(void)removeAllSubElements{
     [(NSMutableArray *)self.subElements removeAllObjects];
}
@end
