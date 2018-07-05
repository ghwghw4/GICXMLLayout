//
//  GICImageView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICImageView.h"
#import "GICURLConverter.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GICImageView
static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"url":[[GICURLConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(GICImageView *)target setImageUrl:value];
                         }]
                         };
}

+(NSString *)gic_elementName{
    return @"image";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

-(void)setImageUrl:(NSURL *)imageUrl{
    _imageUrl = imageUrl;
    [self sd_setImageWithURL:imageUrl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
