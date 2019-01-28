//
//  GICMoveAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICTransformAnimation.h"
#import "CGPointConverter.h"

@interface GICMoveAnimation : GICTransformAnimation{
    CGPointConverter *pointConverter;
}
@property (nonatomic,copy)NSValue *fromValue;
@property (nonatomic,copy)NSValue *toValue;
@end
