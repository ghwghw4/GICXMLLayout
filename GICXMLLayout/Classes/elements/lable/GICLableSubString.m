//
//  GICLableSubString.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "GICLableSubString.h"
#import "NSObject+LayoutView.h"
#import "GDataXMLNode.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"


@implementation GICLableSubString

//+(NSString *)gic_elementName{
//    return @"s";
//}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 NSMutableDictionary *dict = ((GICLableSubString *)target)->attrs;
                 [dict setObject:value forKey:NSForegroundColorAttributeName];
             }],
             @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 NSMutableDictionary *dict = ((GICLableSubString *)target)->attrs;
                 [dict setObject:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
             }],
             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 NSMutableDictionary *dict = ((GICLableSubString *)target)->attrs;
                 [dict setObject:value forKey:NSBackgroundColorAttributeName];
             }],
             };
}


-(void)parseElement:(GDataXMLElement *)element{
    attrs = [NSMutableDictionary dictionary];
    [super parseElement:element];
    
//     NSString *str = [element stringValue];
//    [super initWithString:str attributes:attrs];
    
    NSString *str = [element stringValue];
//    if(attrs.count>0){
//       [self appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:attrs]];
//    }else{
//        [self appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
//    }
}
@end
