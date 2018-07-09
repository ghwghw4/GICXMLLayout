//
//  GICViewExtensionProperties.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import <Foundation/Foundation.h>

typedef enum {
    GICDockPanelHorizalModel_Center,
    GICDockPanelHorizalModel_Left,
    GICDockPanelHorizalModel_Right
}GICDockPanelHorizalModel;

typedef enum {
    GICDockPanelVerticalModel_Center,
    GICDockPanelVerticalModel_Top,
    GICDockPanelVerticalModel_Bottom
}GICDockPanelVerticalModel;

@interface GICViewExtensionProperties : NSObject
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


/**
 强制的父级元素。有事后有些元素并不能正确获取父级元素，这时候可以设置一个强制的父级元素来准确获取
 */
@property (nonatomic,weak)id foreSuperElement;
@end
