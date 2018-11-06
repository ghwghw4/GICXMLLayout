//
//  GICListView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListView.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICBoolConverter.h"
#import "GICListHeader.h"
#import "GICListFooter.h"
#import "GICListSection.h"
#define RACWindowCount 10
#import "GICListItem.h"

@interface GICListView ()<ASTableDelegate,ASTableDataSource,GICListSectionProtocol>{
    id<RACSubscriber> insertItemsSubscriber;
    NSMutableDictionary<NSNumber *,GICListSection *>*_sectionsMap;
    GICListHeader *_header;
    GICListFooter *_footer;
}
@end

@implementation GICListView
+(NSString *)gic_elementName{
    return @"list";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"separator-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICCollectionView *)target).separatorStyle = [value integerValue];
             } withGetter:^id(id target) {
                 return @(((GICCollectionView *)target).separatorStyle);
             }],
             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICCollectionView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsVerticalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICCollectionView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsHorizontalScrollIndicator:[value boolValue]];
                 }];
             }],
             };
}
-(id)init{
    self = [super init];
    _sectionsMap = [NSMutableDictionary dictionary];
    self.dataSource = self;
    self.delegate = self;
    // 创建一个0.2秒的节流阀
    @weakify(self)
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self->insertItemsSubscriber = subscriber;
        return nil;
    }] bufferWithTime:0.1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if(self){
            NSArray *insertArray = nil;
            // 每次只加载最多RACWindowCount 条数据，这样避免一次性加载过多的话会影响显示速度
            if(x.count<=RACWindowCount){
                insertArray = [x allObjects];
            }else{
                insertArray = [NSMutableArray array];
                [[x allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(idx<RACWindowCount){
                        [(NSMutableArray *)insertArray addObject:obj];
                    }else{
                        [self->insertItemsSubscriber sendNext:obj];
                    }
                }];
            }
            
            NSMutableArray *mutArray=[NSMutableArray array];
            for(int i=0 ;i<insertArray.count;i++){
                NSDictionary *itemInfo = insertArray[i];
                GICListSection *section = self->_sectionsMap[[itemInfo objectForKey:@"section"]];
                [mutArray addObject:[NSIndexPath indexPathForRow:section.items.count inSection:section.sectionIndex]];
                [section.items addObject:itemInfo[@"item"]];
            }
            [self insertRowsAtIndexPaths:mutArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    return self;
}


#pragma mark ASTableDataSource

-(NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode{
    return _sectionsMap.count;
}

-(NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    return [[_sectionsMap.allValues objectAtIndex:section] items].count;
}

-(ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath{
    GICListItem *item = [[[_sectionsMap.allValues objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        [item prepareLayout];
        return item;
    };
    return cellNodeBlock;
}

#pragma mark Header & Footer

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    GICListSection *listsection = [_sectionsMap.allValues objectAtIndex:section];
    if(listsection.header){
        ASLayout *layout = [listsection.header layoutThatFits:ASSizeRangeMake(CGSizeMake(tableView.bounds.size.width, 0), CGSizeMake(tableView.bounds.size.width, MAXFLOAT))];
        return layout.size.height;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GICListSection *listsection = [_sectionsMap.allValues objectAtIndex:section];
    if(listsection.header){
        return listsection.header.view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    GICListSection *listsection = [_sectionsMap.allValues objectAtIndex:section];
    if(listsection.footer){
        ASLayout *layout = [listsection.footer layoutThatFits:ASSizeRangeMake(CGSizeMake(tableView.bounds.size.width, 0), CGSizeMake(tableView.bounds.size.width, MAXFLOAT))];
        return layout.size.height;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    GICListSection *listsection = [_sectionsMap.allValues objectAtIndex:section];
    if(listsection.footer){
        return listsection.footer.view;
    }
    return nil;
}

#pragma mark ASTableDelegate
-(void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 触发选中事件
    GICListItem *item = [tableNode nodeForRowAtIndexPath:indexPath];
    [item.itemSelectEvent fire:nil];
}

#pragma mark GIC Parse

-(id)gic_addSubElement:(id)subElement{
    if ([subElement isKindOfClass:[GICListSection class]]){
        [self->_sectionsMap setObject:subElement forKey:@([subElement sectionIndex])];
        return subElement;
    }else if ([subElement isKindOfClass:[GICListHeader class]]){
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

-(NSArray *)gic_subElements{
    NSMutableArray *temp = [_sectionsMap.allValues mutableCopy];
    if(_header){
        [temp addObject:_header];
    }
    if(_footer){
        [temp addObject:_footer];
    }
    return temp;
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    NSString *elName = [element name];
    if([elName isEqualToString:[GICListSection gic_elementName]]){
        return  [[GICListSection alloc] initWithOwner:self withSectionIndex:_sectionsMap.count];
    }else if([elName isEqualToString:[GICListHeader gic_elementName]]){
        return  [GICListHeader new];
    }else if([elName isEqualToString:[GICListFooter gic_elementName]]){
        return  [GICListFooter new];
    }
    return [super gic_parseSubElementNotExist:element];
}

-(void)gic_removeSubElements:(NSArray<GICListSection *> *)subElements{
    [super gic_removeSubElements:subElements];
    if(subElements.count==0)
        return;
    NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
    for(id subElement in subElements){
        if([subElement isKindOfClass:[GICListSection class]]){
            NSInteger sectionIndex = [(GICListSection *)subElement sectionIndex];
            [idxSet addIndex:sectionIndex];
            [_sectionsMap removeObjectForKey:@(sectionIndex)];
        }
    }
    if(_sectionsMap.count==0){
        [self reloadData];
    }else if(idxSet.count>0){
        [self reloadSections:idxSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)didLoad{
    [super didLoad];
    if(_header){
        self.view.tableHeaderView = _header.view;
        @weakify(self)
        _header.sizeChangedBlock = ^(CGSize size) {
            @strongify(self)
            self.view.tableHeaderView = self->_header.view;
        };
    }
    
    if(_footer){
        self.view.tableFooterView = _footer.view;
        @weakify(self)
        _footer.sizeChangedBlock = ^(CGSize size) {
            @strongify(self)
            self.view.tableFooterView = self->_footer.view;
        };
    }
}

#pragma mark GICListSectionProtocol
-(void)onItemAddedInSection:(NSDictionary *)itemInfo{
    [self->insertItemsSubscriber sendNext:itemInfo];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [self reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
}
@end
