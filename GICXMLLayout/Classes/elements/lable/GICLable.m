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
                             ((GICLable *)target)->mutAttString = [[NSMutableAttributedString alloc] initWithString:value];
                             [(GICLable *)target updateSting];
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

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return propertyConverts;
}

-(void)gic_parseElement:(GDataXMLElement *)element{
    attributes = [NSMutableDictionary dictionary];
    [super gic_parseElement:element];
}

-(void)gic_elementParseCompelte{
    [super gic_elementParseCompelte];
    [self updateSting];
}

-(void)updateSting{
    if(attributes){
        [self->mutAttString setAttributes:self->attributes range:NSMakeRange(0, self->mutAttString.length)];
    }
    self.attributedText = self->mutAttString;
}
//
//-(void)gic_parseElement:(GDataXMLElement *)element{
//    [super gic_parseElement:element];
//}
//
//-(NSArray *)gic_subElements{
//    return attbuteStringArray;
//}
//
//-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
//    attbuteStringArray = [NSMutableArray array];
//    for(GDataXMLElement *child in children){
//        if([supportElementNames containsObject:child.name]){
//            NSMutableAttributedString *s =[[NSMutableAttributedString alloc] initWithXmlElement:child];
//            [s gic_parseElement:child];
//            [attString appendAttributedString:s];
//            [attbuteStringArray addObject:s];
//            if(s.gic_Bindings.count>0){
//                @weakify(self)
//                for(GICDataBinding *b in s.gic_Bindings){
//                    [[b rac_signalForSelector:@selector(refreshExpression)] subscribeNext:^(RACTuple * _Nullable x) {
//                        @strongify(self)
//                        [self updateString];
//                    }];
//                }
//            }
//        }
//    }
//    self.attributedText = attString;
//}
//
//-(void)updateString{
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
//    for(NSMutableAttributedString *att in attbuteStringArray){
//        [attString appendAttributedString:att];
//    }
//    self.attributedText = attString;
//}


//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.preferredMaxLayoutWidth = self.frame.size.width;
//}
//
//-(id)init{
//    self = [super init];
//    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    self.numberOfLines = 0;
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
