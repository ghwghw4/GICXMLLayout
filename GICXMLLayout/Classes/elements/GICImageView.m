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

-(void)setLocalImageName:(NSString *)localImageName{
    _localImageName = localImageName;
    self.clipsToBounds =YES;
    self.image =[UIImage imageNamed:localImageName];
}

@end
