//
//  GICListItem.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListItem.h"

#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICEdgeConverter.h"
#import "GICPanel.h"

@implementation GICListItem
+(NSString *)gic_elementName{
    return @"list-item";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"selection-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 [item setValue:value forKey:@"selectionStyle"];
             }],
             @"event-item-select":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 item.itemSelectEvent = [[GICEvent alloc] initWithExpresion:value];
                 [item.itemSelectEvent attachTo:target];
             }],
             @"separator-inset":[[GICEdgeConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 [item setValue:value forKey:@"separatorInset"];
             }],
             @"accessory-type":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 [item setValue:value forKey:@"accessoryType"];
             }],
             };
}

-(id)init{
    self=[super init];
    self.automaticallyManagesSubnodes = YES;
    return self;
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}


-(NSObject *)gic_getSuperElement{
    return (NSObject *)self.delegate;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self.xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:children[0]];
    }
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(self.itemSelectEvent && selected){
        [self.itemSelectEvent fire:@(selected)];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASStackLayoutSpec *spec= [ASStackLayoutSpec verticalStackLayoutSpec];
    spec.children = self.gic_displayNodes;
    return spec;
}

-(void)createContentView:(GDataXMLDocument *)xmlDoc{
    GICPanel *childElement = (GICPanel *)[NSObject gic_createElement:[xmlDoc rootElement] withSuperElement:self];
    [self gic_addSubElement:childElement];
}

-(void)prepareLayout{
    if(self.subnodes.count == 0){
        [self createContentView:self.xmlDoc];
    }
    self.gic_isAutoInheritDataModel = NO;
    [self gic_updateDataContext:self.gic_DataContext];
}
@end
