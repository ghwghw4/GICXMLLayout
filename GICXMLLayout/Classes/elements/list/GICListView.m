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

@interface GICListView ()<UITableViewDelegate,UITableViewDataSource,GICListItemDelegate>{
    NSMutableArray<GICListItem *> *listItems;
    
    BOOL t;
    
    id<RACSubscriber> subscriber;
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
        self->subscriber = subscriber;
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
        [self->subscriber sendNext:subElement];
    }else{
        [super gic_addSubElement:subElement];
    }
}

#pragma mark datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listItems.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[listItems objectAtIndex:indexPath.row] cellHeight];
    if(height==0)
        return self.defualtItemHeight;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[listItems objectAtIndex:indexPath.row] getCell:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)listItem:(GICListItem *)item cellHeightUpdate:(CGFloat)cellHeight{
    [subscriber sendNext:nil];
}

-(void)dealloc{
    [subscriber sendCompleted];
}
@end
