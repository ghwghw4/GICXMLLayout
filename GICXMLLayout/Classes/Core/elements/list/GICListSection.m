//
//  GICListSection.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/28.
//

#import "GICListSection.h"
#import "GICStringConverter.h"

@implementation GICListSection{
    __weak id<GICListSectionProtocol> _owner;
}
+(NSString *)gic_elementName{
    return @"section";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListSection *item = (GICListSection *)target;
                 item->_title = value;
             } withGetter:^id(id target) {
                 GICListSection *item = (GICListSection *)target;
                 return item.title;
             }]
             };
}

-(id)initWithOwner:(id<GICListSectionProtocol>)owner withSectionIndex:(NSInteger)sectionIndex{
    self = [super init];
    _owner = owner;
    _items = [NSMutableArray array];
    _sectionIndex = sectionIndex;
    return self;
}

-(NSArray *)gic_subElements{
    NSMutableArray *elments = [self.items mutableCopy];
    if(self.header){
        [elments addObject:self.header];
    }
    if(self.footer){
        [elments addObject:self.footer];
    }
    return elments;
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [subElement gic_ExtensionProperties].superElement = self;
        [_owner onItemAddedInSection:@{@"item":subElement,@"section":@(self.sectionIndex)}];
        return subElement;
    }
    else if ([subElement isKindOfClass:[GICListHeader class]]){
        _header = subElement;
        return subElement;
    }else if ([subElement isKindOfClass:[GICListFooter class]]){
        _footer = subElement;
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
    if(self.items.count==0){
        NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
        [idxSet addIndex:self.sectionIndex];
        [self->_owner reloadSections:idxSet];
    }else{
        [self->_owner deleteItemsAtIndexPaths:mutArray];
    }
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    NSString *elName = [element name];
    if([elName isEqualToString:[GICListHeader gic_elementName]]){
        return  [GICListHeader new];
    }else if([elName isEqualToString:[GICListFooter gic_elementName]]){
        return  [GICListFooter new];
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
