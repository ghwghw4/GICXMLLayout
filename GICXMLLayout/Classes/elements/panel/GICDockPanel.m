//
//  GICBoxPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICDockPanel.h"
#import "GICNumberConverter.h"

@implementation GICDockPanel
+(NSString *)gic_elementName{
    return @"dock-panel";
}

-(void)gic_LayoutSubView:(UIView *)view{
    UIEdgeInsets margin = view.gic_ExtensionProperties.margin;
    GICViewExtensionProperties *viewExtensionProperties = view.gic_ExtensionProperties;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if(viewExtensionProperties.width == 0){
            make.left.right.mas_offset(0);
        }else{
            make.width.mas_equalTo(viewExtensionProperties.width);
            switch (viewExtensionProperties.dockHorizalModel) {
                case GICDockPanelHorizalModel_Left:
                     make.left.mas_offset(0);
                    break;
                case GICDockPanelHorizalModel_Center:
                    make.centerX.mas_equalTo(self.mas_centerX);
                    break;
                case GICDockPanelHorizalModel_Right:
                    make.right.mas_offset(0);
                    break;
    
                default:
                    break;
            }
        }
        
        if(viewExtensionProperties.height == 0){
            make.top.bottom.mas_offset(0);
        }else{
            make.height.mas_equalTo(viewExtensionProperties.height);
            switch (viewExtensionProperties.dockVerticalModel) {
                case GICDockPanelVerticalModel_Top:
                    make.top.mas_offset(0);
                    break;
                case GICDockPanelVerticalModel_Center:
                    make.centerY.mas_equalTo(self.mas_centerY);
                    break;
                case GICDockPanelVerticalModel_Bottom:
                    make.bottom.mas_offset(0);
                    break;
                    
                default:
                    break;
            }
        }
    }];
}


-(CGFloat)gic_calcuActualHeight{
    CGFloat height = [super gic_calcuActualHeight];
    
    return height;
}
@end
