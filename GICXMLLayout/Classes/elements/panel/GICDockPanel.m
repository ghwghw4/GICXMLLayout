//
//  GICBoxPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICDockPanel.h"
#import "GICNumberConverter.h"
#import "ASDisplayNode+GICExtension.h"

@implementation GICDockPanel
+(NSString *)gic_elementName{
    return @"dock-panel";
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSMutableArray *children= [NSMutableArray array];
    for(id node in self.childNodes){
        GICNSObjectExtensionProperties *properties = [node gic_ExtensionProperties];
        ASRelativeLayoutSpecPosition hor = ASRelativeLayoutSpecPositionStart;
        switch (properties.dockHorizalModel) {
            case GICDockPanelHorizalModel_Left:
                hor = ASRelativeLayoutSpecPositionStart;
                break;
            case GICDockPanelHorizalModel_Center:
                hor = ASRelativeLayoutSpecPositionCenter;
                break;
            case GICDockPanelHorizalModel_Right:
                hor = ASRelativeLayoutSpecPositionEnd;
                break;
        }
        
        ASRelativeLayoutSpecPosition ver = ASRelativeLayoutSpecPositionStart;
        switch (properties.dockVerticalModel) {
            case GICDockPanelVerticalModel_Top:
                ver = ASRelativeLayoutSpecPositionStart;
                break;
            case GICDockPanelVerticalModel_Center:
                ver = ASRelativeLayoutSpecPositionCenter;
                break;
            case GICDockPanelVerticalModel_Bottom:
                ver = ASRelativeLayoutSpecPositionEnd;
                break;
        }
        
        ASRelativeLayoutSpec *relativeLayout = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:hor verticalPosition:ver sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:[node isKindOfClass:[ASDisplayNode class]]?node:[node layoutSpecThatFits:constrainedSize]];
        [children addObject:relativeLayout];
    }
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:children];
    absoluteSpec.sizing = ASAbsoluteLayoutSpecSizingSizeToFit;
    return absoluteSpec;
}


//-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
//    ASRelativeLayoutSpec *relativeLayout = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:self.childNodeA];
//    return relativeLayout;
//}
@end
