//
//  GICListTableViewCell.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICListTableViewCell.h"
#import "GICPanel.h"

@implementation GICListTableViewCell

-(id)initWithListItem:(GICListItem *)listItem{
    self =[super init];
    self.listItem = listItem;
    self.automaticallyManagesSubnodes = YES;
    return self;
}

-(NSObject *)gic_getSuperElement{
    return self.listItem;
}

-(void)createContentView:(GDataXMLDocument *)xmlDoc{
    GICPanel *childElement = (GICPanel *)[NSObject gic_createElement:[xmlDoc rootElement] withSuperElement:self];
    [self gic_addSubElement:childElement];
}

-(void)setListItem:(GICListItem *)listItem{
    _listItem=listItem;
    
    // 设置cell的样式
    if(listItem.cellStyle.count>0){
        [self setValuesForKeysWithDictionary:listItem.cellStyle];
    }

    if(layoutSubviewsSignlDisposable && !layoutSubviewsSignlDisposable.isDisposed){
        [layoutSubviewsSignlDisposable dispose];
    }
    
    if(self.subnodes.count == 0){
        [self createContentView:listItem.xmlDoc];
    }

    self.gic_isAutoInheritDataModel = NO;
    [self gic_updateDataContext:listItem.gic_DataContenxt];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(self.listItem.itemSelectEvent && selected){
        [self.listItem.itemSelectEvent fire:@(selected)];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASStackLayoutSpec *spec= [ASStackLayoutSpec verticalStackLayoutSpec];
    spec.children = self.subnodes;
    return spec;
}
@end
