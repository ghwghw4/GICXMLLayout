//
//  GICAttributeAnimation.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/15.
//

#import "GICAnimation.h"

@interface GICAttributeAnimation : GICAnimation{
    id fromValue;
    id toValue;
    GICValueConverter *valueConverter;
}
@property (nonatomic,readonly)NSString *atttibuteName;
@property (nonatomic,readonly)NSString *fromString;
@property (nonatomic,readonly)NSString *toString;
@end
