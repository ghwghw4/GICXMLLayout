//
//  GICScaleAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/23.
//

#import "GICTransformAnimation.h"
#import "GICSizeConverter.h"

@interface GICScaleAnimation : GICTransformAnimation{
    GICSizeConverter *sizeConverter;
}
@property (nonatomic,copy)NSValue *fromValue;
@property (nonatomic,copy)NSValue *toValue;
@end
