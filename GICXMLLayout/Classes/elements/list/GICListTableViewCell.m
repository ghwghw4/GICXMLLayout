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

//-(void)gic_addSubElement:(id)childElement{
//    // 必须是panel才能被加入节点
//    if([childElement isKindOfClass:[GICPanel class]]){
//        panel = childElement;
//    }else{
//        [super gic_addSubElement:childElement];
//    }
//}

//-(NSArray *)gic_subElements{
//    if(panel){
//       return @[panel];
//    }
//    return nil;
//}

-(NSObject *)gic_getSuperElement{
    return self.listItem;
}

-(void)createContentView:(GDataXMLDocument *)xmlDoc{
    GICPanel *childElement = (GICPanel *)[GICXMLLayout createElement:[xmlDoc rootElement]];
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
        [self.listItem.itemSelectEvent.eventSubject sendNext:@(selected)];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [self gic_layoutSpecThatFits:constrainedSize];
}
@end
