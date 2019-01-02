//
//  GICCollectionView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/26.
//

#import "GICCollectionView.h"
#define RACWindowCount 10
#import "GICListItem.h"
#import "GICCollectionLayoutDelegate.h"

#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICBoolConverter.h"
#import "GICListHeader.h"
#import "GICListFooter.h"
#import "GICListSection.h"

#define  CollectionViewAttachColumnSpanKey @"collection-view.column-span" //column-span 的属性名称

@interface GICCollectionView ()<ASCollectionDataSource,ASCollectionDelegate,ASCollectionViewLayoutInspecting,GICListSectionProtocol>{
    BOOL t;
    id<RACSubscriber> insertItemsSubscriber;
    
    GICCollectionLayoutDelegate *layoutDelegate;
    
    
    //    GICListHeader *header;
    //    GICListFooter *footer;
    
    //    NSMutableArray<GICListSection *> *_sections;
    NSMutableDictionary<NSNumber *,GICListSection *>*_sectionsMap;
}
@end

@implementation GICCollectionView
+(NSString *)gic_elementName{
    return @"collection-view";
}

+(instancetype)createElementWithXML:(GDataXMLElement *)xmlElement{
    GICCollectionLayoutDelegate *layoutDelegate = [[GICCollectionLayoutDelegate alloc] initWithNumberOfColumns:1];
    return [[self alloc] initWithLayoutDelegate:layoutDelegate layoutFacilitator:nil];
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"columns":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICCollectionView *)target)->layoutDelegate.layoutInfo.numberOfColumns=MAX(1, [value integerValue]);
             } withGetter:^id(id target) {
                 return @(((GICCollectionView *)target)->layoutDelegate.layoutInfo.numberOfColumns);
             }],
             @"column-spacing":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICCollectionView *)target)->layoutDelegate.layoutInfo.columnSpacing=[value floatValue];
             } withGetter:^id(id target) {
                 return @(((GICCollectionView *)target)->layoutDelegate.layoutInfo.columnSpacing);
             }],
             @"row-spacing":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICCollectionView *)target)->layoutDelegate.layoutInfo setValue:value forKey:@"interItemSpacing"];
             } withGetter:^id(id target) {
                 return [NSValue valueWithUIEdgeInsets:((GICCollectionView *)target)->layoutDelegate.layoutInfo.interItemSpacing];
             }],
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
             @"content-inset-behavior":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 if (@available(iOS 11.0, *)) {
                     [(GICCollectionView *)target gic_safeView:^(UIView *view) {
                         [(UIScrollView *)view setContentInsetAdjustmentBehavior:[value integerValue]];
                     }];
                 }
             }],
             @"content-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICCollectionView *)target setValue:value forKey:@"contentInset"];
             } withGetter:^id(id target) {
                 UIEdgeInsets inset = [(GICCollectionView *)target contentInset];
                 return [NSValue valueWithUIEdgeInsets:inset];
             }],
             };
}

+(NSArray<GICAttributeValueConverter *>*)gic_elementAttachAttributs{
    return @[[[GICNumberConverter alloc] initWithName:CollectionViewAttachColumnSpanKey withSetter:^(NSObject *target, id value) {
        [[target gic_ExtensionProperties] setAttachValue:value withAttributeName:CollectionViewAttachColumnSpanKey];
    }]];
}

+(NSInteger)columnSpanFromElement:(id)element{
    NSInteger columnSpan = [[[element gic_ExtensionProperties] attachValueWithAttributeName:CollectionViewAttachColumnSpanKey] integerValue];
    if(columnSpan<1){
        return 1;
    }
    return columnSpan;
}

- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate layoutFacilitator:(id<ASCollectionViewLayoutFacilitatorProtocol>)layoutFacilitator
{
    self = [super initWithLayoutDelegate:layoutDelegate layoutFacilitator:layoutFacilitator];
    _sectionsMap = [NSMutableDictionary dictionary];
    self.style.height = ASDimensionMake(0.1);
    self->layoutDelegate = (GICCollectionLayoutDelegate *)layoutDelegate;
    
    self.dataSource = self;
    self.delegate = self;
    self.layoutInspector = self;
    // 创建一个0.2秒的节流阀
    @weakify(self)
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self->insertItemsSubscriber = subscriber;
        return nil;
    }] bufferWithTime:0.1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
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
    
    [self registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    [self registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
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
    
    [self insertItemsAtIndexPaths:insertArray];
    if(items.count > RACWindowCount){
        [self onDidFinishProcessingUpdates:^{
            // 截取剩余的内容
            [self dealItems:[items subarrayWithRange:NSMakeRange(RACWindowCount, items.count - RACWindowCount)]];
        }];
    }
    
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    //    if([subElement isKindOfClass:[GICListItem class]]){
    //        [subElement gic_ExtensionProperties].superElement = self;
    //        if(!self.isNodeLoaded){
    //            [listItems addObject:subElement];
    //        }else{
    //            [self->insertItemsSubscriber sendNext:subElement];
    //        }
    //        return subElement;
    //    }else
    if ([subElement isKindOfClass:[GICListSection class]]){
        [self->_sectionsMap setObject:subElement forKey:@([subElement sectionIndex])];
        return subElement;
    }
    //    else if ([subElement isKindOfClass:[GICListHeader class]]){
    //        header = subElement;
    //        return subElement;
    //    }else if ([subElement isKindOfClass:[GICListFooter class]]){
    //        footer = subElement;
    //        return subElement;
    //    }
    else{
        return [super gic_willAddAndPrepareSubElement:subElement];
    }
}

-(NSArray *)gic_subElements{
    return [_sectionsMap.allValues mutableCopy];
}


#pragma mark - ASCollectionNodeDelegate / ASCollectionNodeDataSource
- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return _sectionsMap.count;// NOTE:为了在没有数据的时候也能显示header和footer
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return [_sectionsMap[@(section)] items].count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GICListItem *item = [[_sectionsMap[@(indexPath.section)] items] objectAtIndex:indexPath.row];
    item.separatorStyle = self.separatorStyle;
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        [item prepareLayout];
        return item;
    };
    return cellNodeBlock;
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [_sectionsMap.allValues objectAtIndex:indexPath.section].header;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [_sectionsMap.allValues objectAtIndex:indexPath.section].footer;
    }
    return nil;
}

- (ASScrollDirection)scrollableDirections
{
    return ASScrollDirectionVerticalDirections;
}

- (ASSizeRange)collectionView:(nonnull ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return ASSizeRangeZero;
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader] && [_sectionsMap.allValues objectAtIndex:section].header){
        return 1;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter] && [_sectionsMap.allValues objectAtIndex:section].footer){
        return 1;
    }
    return 0;
}

-(void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 触发选中事件
    GICListItem *item = [collectionNode nodeForItemAtIndexPath:indexPath];
    [item.itemSelectEvent fire:nil];
    [collectionNode deselectItemAtIndexPath:indexPath animated:YES];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    NSString *elName = [element name];
    //    if([elName isEqualToString:[GICListHeader gic_elementName]]){
    //        return  [GICListHeader new];
    //    }else if([elName isEqualToString:[GICListFooter gic_elementName]]){
    //        return  [GICListFooter new];
    //    }else
    if([elName isEqualToString:[GICListSection gic_elementName]]){
        return  [[GICListSection alloc] initWithOwner:self withSectionIndex:_sectionsMap.count];
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
        [self reloadSections:idxSet];
    }
}
#pragma mark GICListSectionProtocol
-(void)onItemAddedInSection:(NSDictionary *)itemInfo{
    [self->insertItemsSubscriber sendNext:itemInfo];
}

-(void)dealloc{
    [insertItemsSubscriber sendCompleted];
}
@end

