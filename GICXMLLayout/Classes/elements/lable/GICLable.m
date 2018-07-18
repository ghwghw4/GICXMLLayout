//
//  GICLable.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICLable.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"
#import "GICTextAlignmentConverter.h"
#import "GICXMLLayout.h"
#import "NSObject+LayoutElement.h"
#import "NSMutableAttributedString+GICLableSubString.h"
#import "NSObject+GICDataBinding.h"

@implementation GICLable

static NSArray *supportElementNames;
static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    [super initialize];
    supportElementNames = @[@"s",@"img"];
    propertyConverts = @{
                         @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *att= ((GICLable *)target)->mutAttString;
                             [att deleteCharactersInRange:NSMakeRange(0, att.length)];
                             [att appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
                             [(GICLable *)target updateString];
                         }],
                         @"lines":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(GICLable *)target setMaximumNumberOfLines:[value integerValue]];
                         }],
                         @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [((GICLable *)target)->attributes setValue:value forKey:NSForegroundColorAttributeName];
                         }],
                         @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                              [((GICLable *)target)->attributes setValue:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
                         }],
                         @"text-align":[[GICTextAlignmentConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableParagraphStyle * p = [[NSMutableParagraphStyle alloc] init];
                             p.alignment = [value integerValue];
                             [((GICLable *)target)->attributes setValue:p forKey:NSParagraphStyleAttributeName];
                         }],
                         
                         };
}

+(NSString *)gic_elementName{
    return @"lable";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return propertyConverts;
}

-(id)init{
    self = [super init];
    attributes = [NSMutableDictionary dictionary];
    mutAttString = [[NSMutableAttributedString alloc] init];
    attbuteStringArray = [NSMutableArray array];
    return self;
}

//-(id)init{
//    self = [super init];
////    self.userInteractionEnabled = YES;
//    return self;
//}

//-(void)gic_par

-(void)gic_parseElementCompelete{
    [super gic_parseElementCompelete];
    [self updateString];
}

-(void)updateString{
    if(attbuteStringArray.count>0){
        [self->mutAttString deleteCharactersInRange:NSMakeRange(0, self->mutAttString.length)];
        NSInteger offset = 0;
        for(NSMutableAttributedString *att in attbuteStringArray){
            [self->mutAttString appendAttributedString:att];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attributes];
            if(att.gic_attributDict.count>0){
                [dict addEntriesFromDictionary:att.gic_attributDict];
            }
            [self->mutAttString setAttributes:dict range:NSMakeRange(offset, att.length)];
            offset +=att.length;
        }
    }else{
        if(attributes){
            [self->mutAttString setAttributes:self->attributes range:NSMakeRange(0, self->mutAttString.length)];
        }
    }
    self.attributedText = [self->mutAttString copy];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([supportElementNames containsObject:element.name]){
        NSMutableAttributedString *s =[[NSMutableAttributedString alloc] initWithXmlElement:element];
        [s gic_beginParseElement:element withSuperElement:self];
        [attbuteStringArray addObject:s];
        if(s.gic_Bindings.count>0){
            @weakify(self)
            for(GICDataBinding *b in s.gic_Bindings){
                b.valueUpdate = ^(id value) {
                    @strongify(self)
                    [self updateString];
                };
            }
        }
        return nil;
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
