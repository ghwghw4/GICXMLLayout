//
//  GICBoxPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import "GICDockPanel.h"
#import "GICNumberConverter.h"
#import "ASDisplayNode+GICExtension.h"

static NSString * const GICDockPanelHorizalString =  @"dock-panel.horizal";
static NSString * const GICDockPanelVerticalString =  @"dock-panel.vertical";

@implementation GICDockPanel
+(NSString *)gic_elementName{
    return @"dock-panel";
}

+(NSArray<GICAttributeValueConverter *>*)gic_elementAttachAttributs{
    return @[
             [[GICNumberConverter alloc] initWithName:GICDockPanelHorizalString withSetter:^(NSObject *target, id value) {
                 [[target gic_ExtensionProperties] setAttachValue:value withAttributeName:GICDockPanelHorizalString];
             }],
             [[GICNumberConverter alloc] initWithName:GICDockPanelVerticalString withSetter:^(NSObject *target, id value) {
                 [[target gic_ExtensionProperties] setAttachValue:value withAttributeName:GICDockPanelVerticalString];
             }]];
}

+(GICDockPanelHorizalModel)attachValueHorizalModel:(id)element{
    id v = [[element gic_ExtensionProperties] attachValueWithAttributeName:GICDockPanelHorizalString];
    if(v){
        return (GICDockPanelHorizalModel)[v integerValue];
    }
    return GICDockPanelHorizalModel_Center;
}

+(GICDockPanelVerticalModel)attachValueVerticalModel:(id)element{
    id v = [[element gic_ExtensionProperties] attachValueWithAttributeName:GICDockPanelVerticalString];
    if(v){
        return (GICDockPanelVerticalModel)[v integerValue];
    }
    return GICDockPanelVerticalModel_Center;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    NSMutableArray *children= [NSMutableArray array];
    for(id node in self.gic_displayNodes){
        ASRelativeLayoutSpecPosition hor = ASRelativeLayoutSpecPositionStart;
        switch ([GICDockPanel attachValueHorizalModel:node]) {
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
        switch ([GICDockPanel attachValueVerticalModel:node]) {
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
        
        ASRelativeLayoutSpec *relativeLayout = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:hor verticalPosition:ver sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:node];
        [children addObject:relativeLayout];
    }
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:children];
    absoluteSpec.sizing = ASAbsoluteLayoutSpecSizingSizeToFit;
    return absoluteSpec;
}
@end
