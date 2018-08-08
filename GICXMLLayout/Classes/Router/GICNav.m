//
//  GICNav.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import "GICNav.h"
#import "GICColorConverter.h"
#import "GICRouter.h"

@implementation GICNav
+(NSString *)gic_elementName{
    return @"nav";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [GICUtils mainThreadExcu:^{
                     ((GICNav *)target).view.backgroundColor = value;
                 }];
             }],
             };
}

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[UIViewController class]]){
        [self pushViewController:subElement animated:YES];
        return subElement;
    }
    return [super gic_addSubElement:subElement];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:@"root-page"]){
        NSString *path = [element attributeForName:@"path"].stringValue;
        if(path){
            [GICRouter loadPageFromPath:path withParseCompelete:^(UIViewController *page) {
                page.gic_ExtensionProperties.superElement = self;
                [self pushViewController:page animated:YES];
            }];
        }
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
