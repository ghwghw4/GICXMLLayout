//
//  GICLable.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICLable.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"

@implementation GICLable
+(NSString *)gic_elementName{
    return @"lable";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"text":[[GICStringConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                 [(UILabel *)view setText:value];
             }],
             @"lines":[[GICNumberConverter alloc] initWithPropertySetter:^(UIView *view, id value) {
                 [(UILabel *)view setNumberOfLines:[value integerValue]];
             }]
                 };
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
