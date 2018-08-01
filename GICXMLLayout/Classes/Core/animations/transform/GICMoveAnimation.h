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
@property (nonatomic,strong)NSValue *fromValue;
@property (nonatomic,strong)NSValue *toValue;
@end
