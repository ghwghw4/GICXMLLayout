//
//  GICNSObjectExtensionProperties.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/10.
//

#import <Foundation/Foundation.h>

typedef enum {
    GICDockPanelHorizalModel_Left = 0,
    GICDockPanelHorizalModel_Center = 1,
    GICDockPanelHorizalModel_Right = 2
}GICDockPanelHorizalModel;

typedef enum {
    GICDockPanelVerticalModel_Top = 0,
    GICDockPanelVerticalModel_Center = 1,
    GICDockPanelVerticalModel_Bottom = 2
}GICDockPanelVerticalModel;

@interface GICNSObjectExtensionProperties : NSObject
@property (nonatomic,strong)NSString *name;
// 临时的数据源
@property (nonatomic,strong)id tempDataContext;

/**
 强制的父级元素。有事后有些元素并不能正确获取父级元素，这时候可以设置一个强制的父级元素来准确获取
 */
@property (nonatomic,weak)id foreSuperElement;

@property (nonatomic,assign)GICDockPanelHorizalModel dockHorizalModel;
@property (nonatomic,assign)GICDockPanelVerticalModel dockVerticalModel;
@end
