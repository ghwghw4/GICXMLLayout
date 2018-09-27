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
//#import "GICEdgeConverter.h"
#import "GICBoolConverter.h"

@interface GICCollectionView ()<ASCollectionDataSource,ASCollectionDelegate,ASCollectionViewLayoutInspecting>{
    NSMutableArray<GICListItem *> *listItems;
    BOOL t;
    id<RACSubscriber> insertItemsSubscriber;
    
    GICCollectionLayoutDelegate *layoutDelegate;
}
@end

@implementation GICCollectionView
+(NSString *)gic_elementName{
    return @"grid";
}

+(instancetype)createElementWithXML:(GDataXMLElement *)xmlElement{
    GICCollectionLayoutDelegate *layoutDelegate = [[GICCollectionLayoutDelegate alloc] initWithNumberOfColumns:1 headerHeight:44.0];
    return [[self alloc] initWithLayoutDelegate:layoutDelegate layoutFacilitator:nil];
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"colums":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICCollectionView *)target)->layoutDelegate.layoutInfo.numberOfColumns=[value integerValue];
             }],
//             @"show-ver-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [(GICListView *)target gic_safeView:^(UIView *view) {
//                     [(UIScrollView *)view setShowsVerticalScrollIndicator:[value boolValue]];
//                 }];
//             }],
//             @"show-hor-scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [(GICListView *)target gic_safeView:^(UIView *view) {
//                     [(UIScrollView *)view setShowsHorizontalScrollIndicator:[value boolValue]];
//                 }];
//             }],
             };
}

- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate layoutFacilitator:(id<ASCollectionViewLayoutFacilitatorProtocol>)layoutFacilitator
{
    
    self = [super initWithLayoutDelegate:layoutDelegate layoutFacilitator:layoutFacilitator];
    
    listItems = [NSMutableArray array];
    self.style.height = ASDimensionMake(0.1);
    self->layoutDelegate = (GICCollectionLayoutDelegate *)layoutDelegate;
    self->layoutDelegate.target = self;
    
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
            
            NSInteger index = self->listItems.count;
            [self->listItems addObjectsFromArray:insertArray];
            if(index==0){
                [self reloadData];
            }else{
                NSMutableArray *mutArray=[NSMutableArray array];
                for(int i=0 ;i<insertArray.count;i++){
                    [mutArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                    index ++;
                }
                [self insertItemsAtIndexPaths:mutArray];
            }
        }
    }];
    
    
    return self;
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [subElement gic_ExtensionProperties].superElement = self;
        if(!self.isNodeLoaded){
            [listItems addObject:subElement];
        }else{
            [self->insertItemsSubscriber sendNext:subElement];
        }
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
            [mutArray addObject:[NSIndexPath indexPathForRow:[listItems indexOfObject:subElement] inSection:0]];
        }
    }
    [listItems removeObjectsInArray:subElements];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self->listItems.count==0){
            [self reloadData];
        }else{
            [self deleteItemsAtIndexPaths:mutArray];
        }
    });
}

-(NSArray *)gic_subElements{
    return [listItems copy];
}


#pragma mark - ASCollectionNodeDelegate / ASCollectionNodeDataSource
//- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
//{
//    return 1;
//}
//
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return [listItems count];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GICListItem *item = [self->listItems objectAtIndex:indexPath.row];
    item.separatorStyle = self.separatorStyle;
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        [item prepareLayout];
        return item;
    };
    return cellNodeBlock;
}

- (ASScrollDirection)scrollableDirections
{
    return ASScrollDirectionVerticalDirections;
}

- (ASSizeRange)collectionView:(nonnull ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return ASSizeRangeZero;
}

-(void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 触发选中事件
    GICListItem *item = [collectionNode nodeForItemAtIndexPath:indexPath];
    [item.itemSelectEvent fire:nil];
}

-(void)dealloc{
    [insertItemsSubscriber sendCompleted];
}
@end

