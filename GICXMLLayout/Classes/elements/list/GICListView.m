//
//  GICListView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListView.h"
#import "NSObject+GICDataContext.h"
#import "GICListItem.h"

@interface GICListView ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray<GICListItem *> *listItems;
    
    BOOL t;
}
@end

@implementation GICListView
+(NSString *)gic_elementName{
    return @"list";
}

//-(NSArray *)dataArray{
//    id tmp =  self.gic_DataContenxt;
//    if([tmp isKindOfClass:[NSArray class]]){
//        return tmp;
//    }
//    return nil;
//}

-(id)init{
    self = [super init];
    listItems = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    return self;
}

-(void)gic_addSubElement:(id)subElement{
    NSAssert([subElement isKindOfClass:[GICListItem class]], @"list 的子元素必须是list-item");
    if([subElement isKindOfClass:[GICListItem class]]){
        [listItems addObject:subElement];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!t){
        [self reloadData];
        t = YES;
    }
    
}

#pragma mark datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listItems.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[listItems objectAtIndex:indexPath.row] cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [listItems objectAtIndex:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
@end
