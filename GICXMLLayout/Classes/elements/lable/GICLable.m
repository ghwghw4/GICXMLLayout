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

@implementation GICLable

static NSArray *supportElementNames;
static NSDictionary<NSString *,GICValueConverter *> *propertyConverts = nil;
+(void)initialize{
    supportElementNames = @[@"s",@"img"];
    propertyConverts = @{
                         @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UILabel *)target setText:value];
                         }],
                         @"lines":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UILabel *)target setNumberOfLines:[value integerValue]];
                         }],
                         @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UILabel *)target setTextColor:value];
                         }],
                         @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UILabel *)target setFont:[UIFont systemFontOfSize:[value floatValue]]];
                         }],
                         @"text-align":[[GICTextAlignmentConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(UILabel *)target setTextAlignment:[value integerValue]];
                         }],
                         
                         };
}

+(NSString *)gic_elementName{
    return @"lable";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    for(GDataXMLElement *child in children){
        if([supportElementNames containsObject:child.name]){
            NSMutableAttributedString *s =[[NSMutableAttributedString alloc] initWithXmlElement:child];
            [s gic_parseElement:child];
            [attString appendAttributedString:s];
        }
    }
    self.attributedText = attString;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = self.frame.size.width;
}

-(id)init{
    self = [super init];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.numberOfLines = 0;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
