//
//  GICListView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListView.h"
#import "NSObject+GICDataContext.h"
#import "GICListItem.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
//#import "GICListHeader.h"
//#import "GICListFooter.h"

@interface GICListView ()<ASTableDelegate,ASTableDataSource,GICListItemDelegate>{
    NSMutableArray<GICListItem *> *listItems;
    BOOL t;
    id<RACSubscriber> insertItemsSubscriber;
}
@end

@implementation GICListView
+(NSString *)gic_elementName{
    return @"list";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertyConverters{
    return @{
             @"separator-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target gic_safeView:^(id view) {
                     [view setSeparatorStyle:[value integerValue]];
                 }];
             }],
             };
}

-(id)init{
    self = [super init];
    listItems = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    // 创建一个0.2秒的节流阀
    @weakify(self)
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self->insertItemsSubscriber = subscriber;
        return nil;
    }] bufferWithTime:0.2 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if(self){
            NSMutableArray *mutArray=[NSMutableArray array];
            NSInteger index = self->listItems.count;
            [self->listItems addObjectsFromArray:[x allObjects]];
            for(int i=0 ;i<x.count;i++){
                [mutArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                index ++;
            }
            [self insertRowsAtIndexPaths:mutArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }];

    return self;
}

-(NSArray *)gic_subElements{
    return listItems;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [(GICListItem *)subElement setDelegate:self];
        if(!self.isNodeLoaded){
            [listItems addObject:subElement];
        }else{
            [self->insertItemsSubscriber sendNext:subElement];
        }
    }
    else{
        [super gic_addSubElement:subElement];
    }
}

-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    for(id subElement in subElements){
        NSMutableArray *mutArray=[NSMutableArray array];
        if([subElement isKindOfClass:[GICListItem class]]){
            [mutArray addObject:[NSIndexPath indexPathForRow:[listItems indexOfObject:subElement] inSection:0]];
            [listItems removeObject:(GICListItem *)subElement];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self deleteRowsAtIndexPaths:mutArray withRowAnimation:UITableViewRowAnimationFade];
        });
    }
}

#pragma mark - ASTableDelegate, ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    return listItems.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GICListItem *item = [self->listItems objectAtIndex:indexPath.row];
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        return [item getCell];;
    };
    return cellNodeBlock;
}

-(void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableNode deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


-(void)dealloc{
    [insertItemsSubscriber sendCompleted];
}
@end
