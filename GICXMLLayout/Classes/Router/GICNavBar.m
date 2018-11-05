//
//  GICNavBar.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICNavBar.h"
#import "GICPage.h"
#import "GICStringConverter.h"

@implementation GICNavBar{
    ASDisplayNode *titleNode;
}
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
            titleNode = (ASDisplayNode *)[NSObject gic_createElement:element.children.firstObject withSuperElement:self];
        }
        return nil;
    }
    return [super gic_parseSubElementNotExist:element];
}

-(void)gic_parseElementCompelete{
    ASSizeRange rang = ASSizeRangeMake(CGSizeMake(0, 44),CGSizeMake(320, 44));
    if(self.rightButtons.buttons.count>0){
        NSMutableArray *rightItems = [NSMutableArray array];
        for(ASDisplayNode *node in self.rightButtons.buttons){
            ASLayout *l = [node layoutThatFits:rang];
            node.frame = CGRectMake(0, 0, l.size.width, 44);
            [rightItems addObject:[[UIBarButtonItem alloc] initWithCustomView:node.view]];
        }
        self->page.navigationItem.rightBarButtonItems = rightItems;
    }
    
    if(self.leftButtons.buttons.count>0){
        NSMutableArray *leftItems = [NSMutableArray array];
        for(ASDisplayNode *node in self.leftButtons.buttons){
            ASLayout *l = [node layoutThatFits:rang];
            node.frame = CGRectMake(0, 0, l.size.width, 44);
            [leftItems addObject:[[UIBarButtonItem alloc] initWithCustomView:node.view]];
        }
        self->page.navigationItem.leftBarButtonItems = leftItems;
    }
    
    if(titleNode){
        self->page.navigationItem.titleView = titleNode.view;
    }
}
@end
