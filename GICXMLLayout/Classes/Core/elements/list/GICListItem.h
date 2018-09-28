//
//  GICListItem.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <UIKit/UIKit.h>

@class GICListItem;
@interface GICListItem : ASCellNode
@property (nonatomic,strong)GDataXMLDocument *xmlDoc;
@property (nonatomic,strong)GICEvent *itemSelectEvent;
@property (nonatomic,assign)UITableViewCellSeparatorStyle separatorStyle;

-(void)prepareLayout;
@end
