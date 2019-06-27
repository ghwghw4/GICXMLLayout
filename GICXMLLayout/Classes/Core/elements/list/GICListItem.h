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
@property (nonatomic,strong)UIColor *separatorColor;//分割线颜色
@property (nonatomic,readonly)BOOL isDelete;

-(void)prepareLayout;

@end
