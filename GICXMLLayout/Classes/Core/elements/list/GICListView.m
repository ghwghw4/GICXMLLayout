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
#import "GICListItem.h"
#import "GICColorConverter.h"


#define RACWindowCount 10

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
             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsVerticalScrollIndicator:[value boolValue]];
                 }];
             }],
             @"separator-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(UIView *view) {
                     [(UITableView *)view setSeparatorStyle:[value integerValue]];
                 }];
             }],
             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(UIView *view) {
                     [(UIScrollView *)view setShowsHorizontalScrollIndicator:[value boolValue]];
                 }];
             }],
             // 是否显示索引
             @"show-indexs":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICListView *)target)->_showIndexs  =[value boolValue];
             }],
             // 索引颜色
             @"index-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(UIView *view) {
                     [(UITableView *)view setSectionIndexColor:value];
                 }];
             }],
             @"content-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target setValue:value forKey:@"contentInset"];
             } withGetter:^id(id target) {
                 UIEdgeInsets inset = [(GICListView *)target contentInset];
                 return [NSValue valueWithUIEdgeInsets:inset];
             }],
             
             @"content-inset-behavior":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 if (@available(iOS 11.0, *)) {
                     [(GICListView *)target gic_safeView:^(UIView *view) {
                         [(UIScrollView *)view setContentInsetAdjustmentBehavior:[value integerValue]];
                     }];
                 }
             }],
             };
}
-(id)init{
    self = [super init];
    _sectionsMap = [NSMutableDictionary dictionary];
    self.dataSource = self;
    self.delegate = self;
    // 创建一个0.1秒的节流阀
    @weakify(self)
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self->insertItemsSubscriber = subscriber;
        return nil;
    }] bufferWithTime:0.05 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if(self){
            if(self.isProcessingUpdates){ // 如果list正在处理其他的更新，那么忽略本次更新，进入下一个循环窗口
                [[x allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self->insertItemsSubscriber sendNext:obj];
                }];
                return;
            }
            [self dealItems:[x allObjects]];
        }
    }];
    return self;
}

-(void)dealItems:(NSArray *)items{
    // 每次只加载最多RACWindowCount 条数据，这样避免一次性加载过多的话会影响显示速度
    NSMutableArray *insertArray = [NSMutableArray array];
    for(NSInteger i = 0;i<items.count;i++){
        NSDictionary *itemInfo = items[i];
        GICListSection *section = self->_sectionsMap[[itemInfo objectForKey:@"section"]];
        [insertArray addObject:[NSIndexPath indexPathForRow:section.items.count inSection:section.sectionIndex]];
        [section.items addObject:itemInfo[@"item"]];
        if(insertArray.count == RACWindowCount){
            // 取满了RACWindowCount 个
            break;
        }
    }
    
    // 截取剩余的内容
    NSArray *subArray = nil;
    if(items.count > RACWindowCount){
        subArray =[items subarrayWithRange:NSMakeRange(RACWindowCount, items.count - RACWindowCount)];
    }
    
    if(self.visibleNodes.count==0){
        // NOTE:这里之所以没有采用跟 insertRowsAtIndexPaths 一样的处理方式，那是因为，本身ASD的“bug"。因为如果在reloadDataWithCompletion的回调中后立马获取visibleNodes，这时候获取到的还是0。
        [self reloadDataWithCompletion:^{
            [subArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               [self->insertItemsSubscriber sendNext:obj];
            }];
        }];
    }else{
        [self insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationNone];
        [self onDidFinishProcessingUpdates:^{
            if(subArray) [self dealItems:subArray];
        }];
    }
}


#pragma mark ASTableDataSource

-(NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode{
    return _sectionsMap.count;
}

-(NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    return _sectionsMap[@(section)].items.count;
}

-(ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath{
    GICListItem *item = [_sectionsMap[@(indexPath.section)].items objectAtIndex:indexPath.row];
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        [item prepareLayout];
        return item;
    };
    return cellNodeBlock;
}

#pragma mark Header & Footer

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    GICListSection *listsection = _sectionsMap[@(section)];
    if(listsection.header){
        ASLayout *layout = [listsection.header layoutThatFits:ASSizeRangeMake(CGSizeMake(tableView.bounds.size.width, 0), CGSizeMake(tableView.bounds.size.width, MAXFLOAT))];
        return layout.size.height;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GICListSection *listsection = _sectionsMap[@(section)];
    if(listsection.header){
        return listsection.header.view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    GICListSection *listsection = _sectionsMap[@(section)];
    if(listsection.footer){
        ASLayout *layout = [listsection.footer layoutThatFits:ASSizeRangeMake(CGSizeMake(tableView.bounds.size.width, 0), CGSizeMake(tableView.bounds.size.width, MAXFLOAT))];
        return layout.size.height;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    GICListSection *listsection = _sectionsMap[@(section)];
    if(listsection.footer){
        return listsection.footer.view;
    }
    return [UIView new];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(self.showIndexs){
        NSMutableArray *titles = [NSMutableArray array];
        [[_sectionsMap.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GICListSection *section = self->_sectionsMap[obj];
            if(section.title)
                [titles addObject:section.title];
            else
                [titles addObject:@""];
        }];
        return titles;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
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
    __block NSInteger count = 0;
    [_sectionsMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, GICListSection * _Nonnull obj, BOOL * _Nonnull stop) {
        count +=obj.items.count;
    }];
    if(count==0){
        [self reloadData];
    }else{
      [self reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
