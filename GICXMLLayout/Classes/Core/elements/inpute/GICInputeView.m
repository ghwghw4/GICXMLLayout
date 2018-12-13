//
//  GICInpute.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/5.
//

#import "GICInputeView.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "GICBoolConverter.h"
#import "GICEdgeConverter.h"
#import "GICFontConverter.h"

@implementation GICInputeView
+(NSString *)gic_elementName{
    return @"input-view";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"placehold":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICInputeView *input = (GICInputeView *)target;
                 [input->placeholdString deleteCharactersInRange:NSMakeRange(0, input->placeholdString.length)];
                 [input->placeholdString appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
             }],
             @"placehold-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInputeView *)target)->placeholdAttributs setObject:value forKey:NSForegroundColorAttributeName];
             }],
             @"placehold-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInputeView *)target)->placeholdAttributs setObject:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
             }],
             @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICInputeView *input = (GICInputeView *)target;
                 [input->textString deleteCharactersInRange:NSMakeRange(0, input->textString.length)];
                 [input->textString appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
                 [input updateTextString];
             }],
             @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInputeView *)target)->textAttributs setObject:value forKey:NSForegroundColorAttributeName];
                 [(GICInputeView *)target updateTextString];
             }],
             @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInputeView *)target)->textAttributs setObject:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
                 [(GICInputeView *)target updateTextString];
             }],
             @"font":[[GICFontConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInputeView *)target)->textAttributs setObject:value forKey:NSFontAttributeName];
                 [(GICInputeView *)target updateTextString];
             }],
             @"content-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInputeView *)target setValue:value forKey:@"textContainerInset"];
             } withGetter:^id(id target) {
                 UIEdgeInsets inset = [(GICInputeView *)target textContainerInset];
                 return [NSValue valueWithUIEdgeInsets:inset];
             }],
            
//             @"lines":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [(GICInpute *)target setMaximumLinesToDisplay:[value integerValue]];
//             }],
             @"secure":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInputeView *)target setSecureTextEntry:[value boolValue]];
             }],
//             @"scroll":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [(GICInputeView *)target setScrollEnabled:[value boolValue]];
//             }],
             @"keyboard-type":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInputeView *)target setKeyboardType:[value integerValue]];
             }],
             };
}

-(id)init{
    self = [super init];
    placeholdString = [[NSMutableAttributedString alloc] init];
    textString = [[NSMutableAttributedString alloc] init];
    textAttributs = [NSMutableDictionary dictionary];
    placeholdAttributs = [NSMutableDictionary dictionary];
    return self;
}

-(void)updatePlacholdString{
    if(placeholdAttributs.count>0){
        [placeholdString setAttributes:placeholdAttributs range:NSMakeRange(0, placeholdString.length)];
    }
    self.attributedPlaceholderText = [placeholdString copy];
}

-(void)updateTextString{
    if(textAttributs.count>0){
        [textString setAttributes:textAttributs range:NSMakeRange(0, textString.length)];
    }
    self.attributedText = [textString copy];
}

-(void)gic_parseElementCompelete{
    self.typingAttributes = textAttributs;
    [self updatePlacholdString];
}

-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withSignalBlock:(void (^)(RACSignal *))signalBlock{
    if([attributeName isEqualToString:@"text"]){
        // 这里不能用rac_textSignal，否则会导致事件被拦截，node无法触发textViewDidChange。只能采用方法交换的方式来实现
        dispatch_async(dispatch_get_main_queue(), ^{
            signalBlock( [[self rac_signalForSelector:@selector(textViewDidChange:)] map:^id _Nullable(RACTuple * _Nullable value) {
                UITextView *t = value[0];
                return t.text;
            }]);
        });
    }
}
@end
