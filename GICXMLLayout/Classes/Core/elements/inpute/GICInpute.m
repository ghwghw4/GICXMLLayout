//
//  GICInpute.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/18.
//

#import "GICInpute.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "GICBoolConverter.h"
#import "GICFontConverter.h"


@implementation GICInpute{
    GICEvent *returnEvent;
    GICEvent *textChangedEvent;
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"placehold":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICInpute *input = (GICInpute *)target;
                 [input->placeholdString deleteCharactersInRange:NSMakeRange(0, input->placeholdString.length)];
                 [input->placeholdString appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
                 [input updatePlacholdString];
             }],
             @"placehold-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInpute *)target)->placeholdAttributs setObject:value forKey:NSForegroundColorAttributeName];
             }],
             @"placehold-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICInpute *)target)->placeholdAttributs setObject:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
             }],
             @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setTextColor:value];
                 }];
             }],
             @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setFont:[UIFont systemFontOfSize:[value floatValue]]];
                 }];
             }],
             @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setText:value];
                 }];
             }],
             @"font":[[GICFontConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setFont:value];
                 }];
             }],
             @"secure":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setSecureTextEntry:[value boolValue]];
                 }];
             }],
             
             @"keyboard-type":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICInpute *)target gic_safeView:^(id view) {
                     [view setKeyboardType:[value integerValue]];
                 }];
             }],
             @"event-return":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICInpute *input = (GICInpute *)target;
                 input->returnEvent =  [GICEvent createEventWithExpresion:value withEventName:@"event-return" toTarget:target];
             }],
             @"event-text-changed":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICInpute *input = (GICInpute *)target;
                 input->textChangedEvent =  [GICEvent createEventWithExpresion:value withEventName:@"event-text-changed" toTarget:target];
             }],
             };
}


+(NSString *)gic_elementName{
    return @"input";
}

-(id)init{
    self = [super init];
    [self setViewBlock:^UIView * _Nonnull{
        return [UITextField new];
    }];
    placeholdString = [[NSMutableAttributedString alloc] init];
    placeholdAttributs = [NSMutableDictionary dictionary];
    self.style.height = ASDimensionMake(31);//默认高度31
    return self;
}

-(void)didLoad{
    [super didLoad];
    [(UITextField *)self.view setDelegate:self];
    [(UITextField *)self.view addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textChanged:(UITextField *)textField{
    if(self->textChangedEvent){
        [self->textChangedEvent fire:textField.text];
    }

}

-(void)updatePlacholdString{
    if(self->placeholdAttributs.count>0){
        [self->placeholdString setAttributes:self->placeholdAttributs range:NSMakeRange(0, self->placeholdString.length)];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        ((UITextField *)self.view).attributedPlaceholder = self->placeholdString;
    });
}

-(void)gic_parseElementCompelete{
    [self updatePlacholdString];
}


-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withSignalBlock:(void (^)(RACSignal *))signalBlock{
    if([attributeName isEqualToString:@"text"]){
        [self gic_safeView:^(UIView *view) {
            signalBlock([(UITextField *)view rac_textSignal]);
        }];
    }
}

#pragma mark UITextInputDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    if(returnEvent){
        [returnEvent fire:textField.text];
    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if(self->textChangedEvent){
//        [self->textChangedEvent fire:textField.text];
//    }
//    return true;
//}
@end
