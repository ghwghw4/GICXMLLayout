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

@property (nonatomic,assign)GICDockPanelHorizalModel dockHorizalModel;
@property (nonatomic,assign)GICDockPanelVerticalModel dockVerticalModel;

@property (nonatomic,weak)id superElement;
@property (nonatomic,readonly)NSArray *subElements;

-(void)addSubElement:(id)subElement;

-(void)removeSubElements:(NSArray *)subElments;

-(void)removeAllSubElements;
@end
