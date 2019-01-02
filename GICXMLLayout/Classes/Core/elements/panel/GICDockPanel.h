//
//  GICBoxPanel.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICPanel.h"

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

/**
 dock panel 对margin属性无效
 */
@interface GICDockPanel : GICPanel

@end
