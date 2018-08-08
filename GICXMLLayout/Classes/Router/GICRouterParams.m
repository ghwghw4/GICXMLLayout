//
//  GICRouterParams.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/7.
//

#import "GICRouterParams.h"

@implementation GICRouterParams
-(id)initWithData:(id)data from:(UIViewController *)fromPage{
    self = [super init];
    _data = data;
    _fromPage = fromPage;
    return self;
}
@end
