//
//  GICPage.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICPage.h"
#import "GICStringConverter.h"
#import "GICColorConverter.h"
#import "GICPanel.h"
#import "GICStackPanel.h"
#import "GICNavBar.h"

@interface GICPage (){
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
//             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [((GICPage *)target)->viewNode setBackgroundColor:value];
//             }],
             };
}

#pragma mark - Lifecycle Methods
-(id)initWithXmlElement:(GDataXMLElement *)element{
    [self gic_beginParseElement:element withSuperElement:nil];
    self = [super initWithNode:_displayNode];
    return self;
}

//- (instancetype)init
//{
//    self = [super initWithNode:_displayNode];
//    return self;
//}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        NSAssert(_displayNode == nil, @"page 只允许添加一个子元素");
        _displayNode =subElement;
        [(ASDisplayNode *)subElement gic_ExtensionProperties].superElement = self;
    }else{
        [super gic_addSubElement:subElement];
    }
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:[GICNavBar gic_elementName]]){
        return [GICNavBar new];
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
