//
//  GICNavBar.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICNavBar.h"
#import "GICPage.h"
#import "GICNavBarButton.h"
#import "GICStringConverter.h"

@implementation GICNavBar
+(NSString *)gic_elementName{
    return @"nav-bar";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertyConverters{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [GICUtils mainThreadExcu:^{
                     [[((GICNavBar *)target)->navbar topItem] setTitle:value];
                 }];
                 
             }],
             //             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
             //                 [((GICPage *)target)->viewNode setBackgroundColor:value];
             //             }],
             };
}

-(id)init{
    self = [super init];
    
    return self;
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(GICPage *)superElment{
    NSAssert([superElment isKindOfClass:[GICPage class]], @"nav-bar 必须是page的子元素");
    [GICUtils mainThreadExcu:^{
        self->navbar = superElment.navigationController.navigationBar;
    }];
    [super gic_beginParseElement:element withSuperElement:superElment];
}

-(void)dealloc{
    
}
@end
