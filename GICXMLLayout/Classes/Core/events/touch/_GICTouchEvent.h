//
//  _GICTouchEvent.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/31.
//

#import <Foundation/Foundation.h>
#import "GICEvent.h"

typedef NS_OPTIONS(NSUInteger, GICCustomTouchEventMethodOverride)
{
    GICCustomTouchEventMethodOverrideNone               = 0,
    GICCustomTouchEventMethodOverrideTouchesBegan       = 1 << 0,
    GICCustomTouchEventMethodOverrideTouchesCancelled   = 1 << 1,
    GICCustomTouchEventMethodOverrideTouchesEnded       = 1 << 2,
    GICCustomTouchEventMethodOverrideTouchesMoved       = 1 << 3,
};

@interface _GICTouchEvent : GICEvent{
    BOOL isRejectEnum;//知否注入了枚举
}
@property (nonatomic,assign,readonly)GICCustomTouchEventMethodOverride overrideType;

+(void)performThreadSafe:(dispatch_block_t)block;
@end
