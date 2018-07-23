//
//  GICAttributeAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICAnimation.h"

@interface GICAttributeAnimation : GICAnimation{
    NSString * fromString;
    NSString * toString;
    GICAttributeValueConverter *valueConverter;
}
@property (nonatomic,readonly)NSString *atttibuteName;
@property (nonatomic,readonly)id fromValue;
@property (nonatomic,readonly)id toValue;

-(POPAnimatableProperty *)createAnimatableProperty;
@end
