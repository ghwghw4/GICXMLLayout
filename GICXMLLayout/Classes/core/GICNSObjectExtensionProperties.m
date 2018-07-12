//
//  GICNSObjectExtensionProperties.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/10.
//

#import "GICNSObjectExtensionProperties.h"

@implementation GICNSObjectExtensionProperties
-(id)init{
    self = [super init];
    _dockHorizalModel = GICDockPanelHorizalModel_Center;
    _dockVerticalModel = GICDockPanelVerticalModel_Center;
    return self;
}
@end
