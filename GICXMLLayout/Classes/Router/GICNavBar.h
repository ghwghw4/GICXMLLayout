//
//  GICNavBar.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//
#import "GICNavbarButtons.h"
@interface GICNavBar : NSObject{
   __weak UINavigationBar *navbar;
}
@property (nonatomic,strong,readonly)GICNavbarButtons *rightButtons;
@property (nonatomic,strong,readonly)GICNavbarButtons *leftButtons;
@end
