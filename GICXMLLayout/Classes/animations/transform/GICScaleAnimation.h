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
@property (nonatomic,strong)NSValue *fromValue;
@property (nonatomic,strong)NSValue *toValue;
@end
