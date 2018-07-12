//
//  GICImageView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICImageView.h"
#import "GICURLConverter.h"
#import "GICNumberConverter.h"
#import "GICStringConverter.h"

@implementation GICImageView
+(NSString *)gic_elementName{
    return @"image";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return  @{
              @"url":[[GICURLConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICImageView *)target setURL:value];
              }],
              @"local-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICImageView *)target setLocalImageName:value];
              }],
              @"fill-mode":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICImageView *)target setContentMode:[value integerValue]];
              }],
              };;
}

//-(void)setImageUrl:(NSURL *)imageUrl{
//    _imageUrl = imageUrl;
//    self.clipsToBounds =YES;
//    [self sd_setImageWithURL:imageUrl];
//}

-(void)setLocalImageName:(NSString *)localImageName{
    _localImageName = localImageName;
    self.clipsToBounds =YES;
    self.image =[UIImage imageNamed:localImageName];
}

//-(void)gic_elementParseCompelte{
//    [super gic_elementParseCompelte];
//    if(self.localImageName && self.image){
//        if(self.gic_ExtensionProperties.width ==0)
//            self.gic_ExtensionProperties.width = self.image.size.width;
//        if(self.gic_ExtensionProperties.height == 0)
//            self.gic_ExtensionProperties.height = self.image.size.height;
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
