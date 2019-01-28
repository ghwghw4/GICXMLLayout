//
//  GICNavBar.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//
#import "GICNavbarButtons.h"
@interface GICNavBar : NSObject{
   __weak ASViewController *page;
}
@property (nonatomic,readonly)GICNavbarButtons *rightButtons;
@property (nonatomic,readonly)GICNavbarButtons *leftButtons;
@end
