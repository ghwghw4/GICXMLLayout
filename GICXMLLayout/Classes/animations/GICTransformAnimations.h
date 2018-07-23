//
//  GICTransformAnimations.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/23.
//

#import <Foundation/Foundation.h>
#import "GICAnimation.h"
#import "GICTransformAnimation.h"
@interface GICTransformAnimations : GICAnimation{
    NSMutableArray<GICTransformAnimation *> *transforms;
}
@end
