//
//  GICListItem.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <UIKit/UIKit.h>
#import "GICListTableViewCell.h"

@class GICListItem;

@protocol GICListItemDelegate

-(void)listItem:(GICListItem *)item cellHeightUpdate:(CGFloat)cellHeight;

@end

@interface GICListItem : NSObject<LayoutElementProtocol>{
//    UIView *elementView;
    GDataXMLDocument *xmlDoc;
    GICListTableViewCell *tempcell;
}

@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong,readonly)NSString *identifyString;

@property (nonatomic) UITableViewCellSelectionStyle   selectionStyle;

@property (nonatomic,weak)id<GICListItemDelegate> delegate;

-(GICListTableViewCell *)getCell:(UITableView *)target;
@end
