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

@implementation NSMutableAttributedString (GICLableSubString)

static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    propertyConverts = @{
                         @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str addAttribute:NSForegroundColorAttributeName value:value range:NSMakeRange(0, str.length)];
                         }],
                         @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[value floatValue]] range:NSMakeRange(0, str.length)];
                         }],
                         @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             [str addAttribute:NSBackgroundColorAttributeName value:value range:NSMakeRange(0, str.length)];
                         }],
                         @"img-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *str = (NSMutableAttributedString *)target;
                             
                             NSTextAttachment * textAttachment = [[NSTextAttachment alloc ] initWithData:nil ofType:nil];
                             textAttachment.image = [UIImage imageNamed:value];
                             NSAttributedString *attImage=[NSAttributedString attributedStringWithAttachment:textAttachment];
                             [str appendAttributedString:attImage];
                         }],
                         };
}


+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

-(id)initWithXmlElement:(GDataXMLElement *)xmlElement{
    NSLog(@"name = %@",xmlElement.name);
    if([xmlElement.name isEqualToString:@"img"]){
        self = [self init];
    }else{
        NSString *text = [xmlElement stringValueOrginal];
        if([text length]==0){
            text = [[xmlElement attributeForName:@"text"] stringValueOrginal];
        }
        self = [self initWithString:text];
    }
    return self;
}
@end
