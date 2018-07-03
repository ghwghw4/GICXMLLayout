//
//  NSMutableAttributedString+GICLableSubString.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "NSMutableAttributedString+GICLableSubString.h"
#import "NSObject+LayoutView.h"
#import "GDataXMLNode.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"

@implementation NSMutableAttributedString (GICLableSubString)


+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
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
             };
}

+(NSString *)gic_elementName{
    return @"s";
}

-(void)parseElement:(GDataXMLElement *)element{
//    attrs = [NSMutableDictionary dictionary];
    [super parseElement:element];
    
    //     NSString *str = [element stringValue];
    //    [super initWithString:str attributes:attrs];
    
//    NSString *str = [element stringValue];
    
//    [self add]
    //    if(attrs.count>0){
    //       [self appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:attrs]];
    //    }else{
    //        [self appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
    //    }
}
@end
