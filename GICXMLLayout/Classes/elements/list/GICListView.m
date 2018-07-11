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
#import "GICListHeader.h"
#import "GICListFooter.h"

@interface GICListView ()<ASTableDelegate,ASTableDataSource,GICListItemDelegate>{
    NSMutableArray<GICListItem *> *listItems;
    BOOL t;
    id<RACSubscriber> reloadSubscriber;
}
@end

@implementation GICListView
+(NSString *)gic_elementName{
    return @"list";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"defualt-item-height":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICListView *)target setDefualtItemHeight:[value floatValue]];
             }],
             @"separator-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [[(GICListView *)target view] setSeparatorStyle:[value integerValue]];
             }],
             @"separator-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [[(GICListView *)target view] setValue:value forKey:@"separatorInset"];
             }],
             };
}

-(id)init{
    self = [super init];
    listItems = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    // 创建一个0.2秒的节流阀
    __weak typeof(self) wself = self;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self->reloadSubscriber = subscriber;
        return nil;
    }] throttle:0.2] subscribeNext:^(id  _Nullable x) {
        [wself reloadData];
    }];
    return self;
}

-(NSArray *)gic_subElements{
    return listItems;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICListItem class]]){
        [(GICListItem *)subElement setDelegate:self];
        [listItems addObject:subElement];
        [self->reloadSubscriber sendNext:nil];
    }
//    else if ([subElement isKindOfClass:[GICListHeader class]]){
//        self.tableHeaderView = subElement;
//        [self.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(self.mas_width);
//        }];
//    }else if ([subElement isKindOfClass:[GICListFooter class]]){
//        self.tableFooterView = subElement;
//        [self.tableFooterView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(self.mas_width);
//        }];
//    }
    else{
        [super gic_addSubElement:subElement];
    }
}

-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    for(id subElement in subElements){
        if([subElement isKindOfClass:[GICListItem class]]){
            [listItems removeObject:(GICListItem *)subElement];
        }
        [self->reloadSubscriber sendNext:nil];
    }
}

#pragma mark - ASTableDelegate, ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    return listItems.count;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat height = [[listItems objectAtIndex:indexPath.row] cellHeight];
//    if(height==0)
//        return self.defualtItemHeight;
//    return height;
//}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[listItems objectAtIndex:indexPath.row] getCell:self];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.5;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [UIView new];
//}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}
-(void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableNode deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)listItem:(GICListItem *)item cellHeightUpdate:(CGFloat)cellHeight{
    [reloadSubscriber sendNext:nil];
}

-(void)dealloc{
    [reloadSubscriber sendCompleted];
}
@end
