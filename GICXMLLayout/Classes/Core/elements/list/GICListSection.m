//
//  GICListSection.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/28.
//

#import "GICListSection.h"

@implementation GICListSection{
    __weak GICCollectionView *_owner;
}
+(NSString *)gic_elementName{
    return @"section";
}

-(id)initWithOwner:(GICCollectionView *)owner withSectionIndex:(NSInteger)sectionIndex{
    self = [super init];
    _owner = owner;
    _items = [NSMutableArray array];
    _sectionIndex = sectionIndex;
    return self;
}

-(NSArray *)gic_subElements{
    return [self.items copy];
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [subElement gic_ExtensionProperties].superElement = self;
        [_owner onItemAddedInSection:@{@"item":subElement,@"section":@(self.sectionIndex)}];
        return subElement;
    }
    else{
        return [super gic_addSubElement:subElement];
    }
}

-(void)gic_removeSubElements:(NSArray<GICListItem *> *)subElements{
    [super gic_removeSubElements:subElements];
    if(subElements.count==0)
        return;
    NSMutableArray *mutArray=[NSMutableArray array];
    for(id subElement in subElements){
        if([subElement isKindOfClass:[GICListItem class]]){
            [mutArray addObject:[NSIndexPath indexPathForRow:[_items indexOfObject:subElement] inSection:_sectionIndex]];
        }
    }
    [_items removeObjectsInArray:subElements];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_owner deleteItemsAtIndexPaths:mutArray];
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(self->listItems.count==0){
//            [self reloadData];
//        }else{
//            [self deleteItemsAtIndexPaths:mutArray];
//        }
//    });
}
@end
