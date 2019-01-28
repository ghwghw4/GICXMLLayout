//
//  GICRotateAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/23.
//

#import "GICTransformAnimation.h"
#import "GICNumberConverter.h"

@interface GICRotateAnimation : GICTransformAnimation{
    GICNumberConverter *numberConverter;
}
@property (nonatomic,copy)NSNumber *fromValue;
@property (nonatomic,copy)NSNumber *toValue;
@end
