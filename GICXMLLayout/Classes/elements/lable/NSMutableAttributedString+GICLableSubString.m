//
//  NSMutableAttributedString+GICLableSubString.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "NSMutableAttributedString+GICLableSubString.h"
#import "NSObject+LayoutElement.h"
#import "GDataXMLNode.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"
#import "GICStringConverter.h"
#import <objc/runtime.h>

@implementation NSMutableAttributedString (GICLableSubString)

-(void)setGic_attributDict:(NSMutableDictionary *)gic_attributDict{
    objc_setAssociatedObject(self, "gic_attributDict", gic_attributDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)gic_attributDict{
    return objc_getAssociatedObject(self, "gic_attributDict");
}

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str.gic_attributDict setValue:value forKey:NSForegroundColorAttributeName];
                         }],
                         @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str.gic_attributDict setValue:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
                         }],
                         @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str.gic_attributDict setValue:value forKey:NSBackgroundColorAttributeName];
                         }],
                         @"img-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             NSTextAttachment * textAttachment = [[NSTextAttachment alloc ] initWithData:nil ofType:nil];
                             textAttachment.image = [UIImage imageNamed:value];
                             NSAttributedString *attImage=[NSAttributedString attributedStringWithAttachment:textAttachment];
                             [str appendAttributedString:attImage];
                         }],
                         @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str deleteCharactersInRange:NSMakeRange(0, str.length)];
                             [str appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
                         }],
                         };
}


+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertyConverters{
    return propertyConverts;
}

-(id)initWithXmlElement:(GDataXMLElement *)xmlElement{
    if([xmlElement.name isEqualToString:@"img"]){
        self = [self init];
    }else{
        NSString *text = [xmlElement stringValueOrginal];
        self = [self initWithString:text];
    }
    self.gic_attributDict = [NSMutableDictionary dictionary];
    return self;
}
@end
