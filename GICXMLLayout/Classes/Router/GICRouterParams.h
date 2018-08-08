//
//  GICRouterParams.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/7.
//

#import <Foundation/Foundation.h>

/**
 封装了导航参数。在pop、或者push的时候都可以使用。
 */
@interface GICRouterParams : NSObject

/**
导航参数。
 tips:这里一开始考虑的是使用NSDicatinary的，但是有时候可能需要直接以一个对象多为参数，那么NSDicatinary就可能不方便了。因此这里使用id
 */
@property(nonatomic,strong,readonly)id data;

@property(nonatomic,weak,readonly)UIViewController *fromPage;

-(id)initWithData:(id)data from:(UIViewController *)fromPage;
@end
