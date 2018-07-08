//
//  GICListItem.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListItem.h"
#import "GICPanel.h"

@implementation GICListItem
+(NSString *)gic_elementName{
    return @"list-item";
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(void)setCellHeight:(CGFloat)cellHeight{
    if(_cellHeight != cellHeight){
        _cellHeight = cellHeight;
        if(self.delegate)
            [self.delegate listItem:self cellHeightUpdate:cellHeight];
    }
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self->xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:children[0]];
    }
}

-(GICListTableViewCell *)getCell:(UITableView *)target{
    if(cell==nil){
        cell = [GICListTableViewCell new];
        GICPanel *childElement = (GICPanel *)[GICXMLLayout createElement:[self->xmlDoc rootElement]];
        if([childElement isKindOfClass:[GICPanel class]]){
            @weakify(self)
            [[childElement rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(self)
                CGFloat h = [childElement gic_calcuActualHeight];
                self.cellHeight = h;
            }];
            childElement.gic_DataContenxt = self.gic_DataContenxt;
            [cell.contentView addSubview:childElement];
            [cell.contentView gic_LayoutSubView:childElement];
        }else{
            NSAssert(false, @"list-item 只支持 panel作为子元素");
        }
    }
    
    cell.gic_isAutoInheritDataModel = NO;
    cell.gic_DataContenxt = self.gic_DataContenxt;
    return cell;
}
@end
