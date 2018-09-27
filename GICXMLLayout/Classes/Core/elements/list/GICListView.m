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
#import "GICBoolConverter.h"
//#import "GICListHeader.h"
//#import "GICListFooter.h"


#define RACWindowCount 10

//@interface GICListView ()<ASTableDelegate,ASTableDataSource>{
//    NSMutableArray<GICListItem *> *listItems;
//    BOOL t;
//    id<RACSubscriber> insertItemsSubscriber;
//}
//@end

@implementation GICListView{
    UITableViewCellSeparatorStyle separatorStyle;
}
+(NSString *)gic_elementName{
    return @"list";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"separator-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICListView *)target)->separatorStyle = [value integerValue];
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

- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate layoutFacilitator:(id<ASCollectionViewLayoutFacilitatorProtocol>)layoutFacilitator{
    self = [super initWithLayoutDelegate:layoutDelegate layoutFacilitator:layoutFacilitator];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return self;
}
@end
