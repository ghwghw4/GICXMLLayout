//
//  GICJSToast.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/22.
//

#import "GICJSToast.h"
#import "GICJSDocument.h"
#import "GICTemplateRef.h"
#import "GICInsetPanel.h"
#import "JSValue+GICJSExtension.h"
#import "GICTapEvent.h"
#import "NSObject+GICEvent.h"

#define Margin 10
#define AnimationDuration 0.2

@implementation GICJSToast{
    ASDisplayNode *contentNode;
    JSManagedValue *managedValueOndismiss;
}
+(instancetype)create:(NSString *)templateName{
    return [[GICJSToast alloc] initWithTemplateName:templateName];
}

-(void)setOndismiss:(JSValue *)ondismiss{
    managedValueOndismiss = [JSManagedValue managedValueWithValue:ondismiss];
    [[[JSContext currentContext] virtualMachine] addManagedReference:managedValueOndismiss withOwner:self];
}

-(JSValue *)ondismiss { return  managedValueOndismiss.value; }

-(instancetype)initWithTemplateName:(NSString *)templateName{
    self = [super init];
    id root = [GICJSDocument rootElementFromJsContext:[JSContext currentContext]];
    GICTemplateRef *ref = [[GICTemplateRef alloc] initWithTemplateName:templateName];
    contentNode = (ASDisplayNode *)[ref parseTemplateFromTarget:root];
    if(contentNode.cornerRadius<=0){
        contentNode.cornerRadius = 5;
    }
    NSAssert([contentNode isKindOfClass:[ASDisplayNode class]], @"toast 内容必须是UI内容");
    
    duration = 2.0f;
    _addToWindow = YES;
    return self;
}

-(void)setAddToWindow:(BOOL)addToWindow{
    _addToWindow = addToWindow;
}

-(BOOL)addToWindow{
    return _addToWindow;
}

-(void)show:(JSValue *)data{
    if([data hasProperty:@"params"]){
        JSManagedValue * ds =  [data[@"params"] gic_ToManagedValue:contentNode];
        // 更新数据源
        [contentNode setGic_DataContext:ds];
    }else{
        [contentNode setGic_DataContext:@{}];
    }
    
    if([data hasProperty:@"duration"]){
        duration = [data[@"duration"] toInt32] / 1000.f;
    }
    
    GICJSToastShowPosition type = [data[@"position"] toInt32];
    
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 2*Margin, [[UIScreen mainScreen] bounds].size.height - 2*Margin);
    ASLayout *layout = [contentNode layoutThatFits:ASSizeRangeMake(CGSizeMake(maxSize.width, 0), maxSize)];
    if(self.addToWindow){
        [[[UIApplication sharedApplication].delegate window] addSubview:contentNode.view];
    }else{
        id root = [GICJSDocument rootElementFromJsContext:[JSContext currentContext]];
        if([root isKindOfClass:[UIViewController class]]){
            [[root view] addSubview:contentNode.view];
        }
    }
    
    
    switch (type) {
            case GICJSToastShowFromBottom:{
                contentNode.frame = CGRectMake(Margin, [UIScreen mainScreen].bounds.size.height - 20 - layout.size.height, layout.size.width, layout.size.height);
                contentNode.transform = CATransform3DMakeTranslation(0, layout.size.height + Margin, 0);
                [UIView animateWithDuration:AnimationDuration animations:^{
                    self->contentNode.transform = CATransform3DIdentity;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:AnimationDuration animations:^{
                        self->contentNode.transform = CATransform3DMakeTranslation(0, layout.size.height + Margin, 0);
                    } completion:^(BOOL finished) {
                        [self dismiss];
                    }];
                });
            }
            break;
            case GICJSToastShowFromCenter:{
                contentNode.frame = CGRectMake(Margin, ([UIScreen mainScreen].bounds.size.height - layout.size.height)/2, layout.size.width, layout.size.height);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self dismiss];
                });
            }
            break;
        default:{
            contentNode.frame = CGRectMake(Margin, ([[UIApplication sharedApplication] isStatusBarHidden]? Margin:[[UIApplication sharedApplication] statusBarFrame].size.height), layout.size.width, layout.size.height);
            contentNode.transform = CATransform3DMakeTranslation(0, -CGRectGetMaxY(contentNode.frame), 0);
            [UIView animateWithDuration:AnimationDuration animations:^{
                self->contentNode.transform = CATransform3DIdentity;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:AnimationDuration animations:^{
                    self->contentNode.transform = CATransform3DMakeTranslation(0, -CGRectGetMaxY(self->contentNode.frame), 0);
                } completion:^(BOOL finished) {
                    [self dismiss];
                }];
            });
        }
            break;
    }
    
    // 添加点击隐藏事件
    @weakify(self)
    GICTapEvent *event = (GICTapEvent *)[contentNode gic_event_findFirstWithEventNameOrCreate:[GICTapEvent eventName]];
    [event.eventSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dismiss];
    }];
}

-(void)dismiss{
    [self->contentNode.view removeFromSuperview];
    [self.ondismiss callWithArguments:nil];
}
@end
