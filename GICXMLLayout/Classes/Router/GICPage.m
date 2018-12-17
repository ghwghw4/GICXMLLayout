//
//  GICPage.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICPage.h"
#import "GICRouter.h"
#import "GICStringConverter.h"
#import "GICColorConverter.h"
#import "GICBoolConverter.h"
#import "GICPanel.h"
#import "GICStackPanel.h"
#import "GICNavBar.h"
#import "GICXMLParserContext.h"
@interface GICPage (){
    GICEvent *eventAppear;
    GICEvent *eventDisappear;
}
@property (nonatomic, strong) ASDisplayNode *displayNode;
@end

@implementation GICPage

+(NSString *)gic_elementName{
    return @"page";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICPage *)target setTitle:value];
             }],
             @"event-appear":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICPage *page = (GICPage *)target;
                 page->eventAppear =  [GICEvent createEventWithExpresion:value withEventName:@"event-appear" toTarget:target];
             } withGetter:^id(id target) {
                 return [target gic_event_findWithEventName:@"event-appear"];
             }],
             @"event-disappear":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICPage *page = (GICPage *)target;
                 page->eventDisappear =  [GICEvent createEventWithExpresion:value withEventName:@"event-disappear" toTarget:target];
             } withGetter:^id(id target) {
                 return [target gic_event_findWithEventName:@"event-disappear"];
             }],
             // tips:不要提供background-color属性，提供了以后有可能会引起其他的问题
//             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [GICUtils mainThreadExcu:^{
//                      [((GICPage *)target).view setBackgroundColor:value];
//                 }];
//             }],
             };
}

#pragma mark - Lifecycle Methods
-(void)gic_parseElementCompelete{
    [super gic_parseElementCompelete];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubnode:_displayNode];
    
    // NOTE:默认去掉返回按钮的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(eventAppear){
        [eventAppear fire:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(eventDisappear){
        [eventDisappear fire:nil];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _displayNode.frame = self.view.bounds;
}



-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        NSAssert(_displayNode == nil, @"page 只允许添加一个子元素");
        _displayNode =subElement;
        [(ASDisplayNode *)subElement gic_ExtensionProperties].superElement = self;
        return subElement;
    }else{
       return [super gic_willAddAndPrepareSubElement:subElement];
    }
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:[GICNavBar gic_elementName]]){
        return [GICNavBar new];
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
