//
//  GICRouterLink.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import "GICRouterLink.h"
#import "GICStringConverter.h"
#import "GICNav.h"
#import "GICRouter.h"
#import "GICDataContextConverter.h"

@implementation GICRouterLink
+(NSString *)gic_elementName{
    return @"bev-router-link";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"path":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICRouterLink *)target setPath:value];
             }],
             @"params":[[GICDataContextConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICRouterLink *)target setParams:value];
             }],
             };
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    if([target isKindOfClass:[ASDisplayNode class]]){
        @weakify(self)
        [target gic_get_tapSignal:^(RACSignal *signal) {
            [[signal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [[self gic_Router] push:self.path withParamsData:self.params];
            }];
        }];
    }
}
@end
