//
//  GICNavBar.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICNavBar.h"
#import "GICPage.h"
#import "GICStringConverter.h"

@implementation GICNavBar
+(NSString *)gic_elementName{
    return @"nav-bar";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [((GICNavBar *)target)->page setTitle:value];
             }],
             //             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
             //                 [((GICPage *)target)->viewNode setBackgroundColor:value];
             //             }],
             };
}

-(id)init{
    self = [super init];
    
    return self;
}

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(GICPage *)superElment{
    NSAssert([superElment isKindOfClass:[GICPage class]], @"nav-bar 必须是page的子元素");
    self->page = superElment;
    [super gic_beginParseElement:element withSuperElement:superElment];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:@"right-buttons"]){
        _rightButtons = [GICNavbarButtons new];
        return self.rightButtons;
    }else if([element.name isEqualToString:@"left-buttons"]){
        _leftButtons = [GICNavbarButtons new];
        return self.leftButtons;
    }else if([element.name isEqualToString:@"title"]){
        if(element.childCount == 1){
            titleNode = (ASDisplayNode *)[NSObject gic_createElement:[element childrenIncludeComment:NO].firstObject withSuperElement:self];
        }
        return nil;
    }
    return [super gic_parseSubElementNotExist:element];
}

-(void)gic_parseElementCompelete{
    if(self.leftButtons){
        self->page.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButtons.view];
        @weakify(self)
        self.leftButtons.sizeChangedBlock = ^(CGSize size) {
            @strongify(self)
            self->page.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButtons.view];
        };
    }
    
    if(self.rightButtons){
        self->page.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtons.view];
        @weakify(self)
        self.rightButtons.sizeChangedBlock = ^(CGSize size) {
            @strongify(self)
            self->page.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButtons.view];
        };
    }
    
    if(titleNode){
        titleNode.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        self->page.navigationItem.titleView = titleNode.view;
    }
}
@end
