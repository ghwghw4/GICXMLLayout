//
//  GICListItem.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import <UIKit/UIKit.h>

@interface GICListItem : UITableViewCell<LayoutElementProtocol>{
//    UIView *elementView;
}
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong,readonly)NSString *identifyString;
@end
