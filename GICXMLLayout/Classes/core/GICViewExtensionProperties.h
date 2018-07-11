//
//  GICViewExtensionProperties.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import <Foundation/Foundation.h>
#import "GICNSObjectExtensionProperties.h"

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

@interface GICViewExtensionProperties : GICNSObjectExtensionProperties
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;


@property (nonatomic,assign)UIEdgeInsets margin;
@property (nonatomic,assign)CGFloat marginTop;
@property (nonatomic,assign)CGFloat marginLeft;
@property (nonatomic,assign)CGFloat marginRight;
@property (nonatomic,assign)CGFloat marginBottom;

//@property (nonatomic,strong)NSString *name;

@property (nonatomic,assign)NSInteger zIndex;

@property (nonatomic,assign)GICDockPanelHorizalModel dockHorizalModel;
@property (nonatomic,assign)GICDockPanelVerticalModel dockVerticalModel;

@end
