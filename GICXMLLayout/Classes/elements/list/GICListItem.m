//
//  GICListItem.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICListItem.h"
#import "GICPanel.h"
#import "GICStringConverter.h"

@implementation GICListItem
+(NSString *)gic_elementName{
    return @"list-item";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"id":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 GICListItem *item = (GICListItem *)target;
                 item->_identifyString = value;
             }],
             };
}

-(BOOL)gic_parseOnlyOneSubElement{
    return YES;
}

-(void)setCellHeight:(CGFloat)cellHeight{
    if(cellHeight>_cellHeight){
        _cellHeight = cellHeight;
        if(self.delegate)
            [self.delegate listItem:self cellHeightUpdate:cellHeight];

    }
//    if(_cellHeight != cellHeight){
//        _cellHeight = cellHeight;
//        if(self.delegate)
//            [self.delegate listItem:self cellHeightUpdate:cellHeight];
//    }
}

-(NSObject *)gic_getSuperElement{
    return (NSObject *)self.delegate;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count==1){
        self->xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:children[0]];
    }
}

-(void)gic_addSubElement:(NSObject *)childElement{
    // 必须是panel才能被加入节点
    if([childElement isKindOfClass:[GICPanel class]]){
        [tempcell.contentView addSubview:(GICPanel *)childElement];
        [tempcell.contentView gic_LayoutSubView:(GICPanel *)childElement];
    }else{
         childElement.gic_DataContenxt = self.gic_DataContenxt;
         [super gic_addSubElement:childElement];
    }
}

-(GICListTableViewCell *)getCell:(UITableView *)target{
    GICListTableViewCell *cell = [target dequeueReusableCellWithIdentifier:self.identifyString];
    if(cell == nil){
         cell = [[GICListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifyString];
        tempcell = cell;
        GICPanel *childElement = (GICPanel *)[GICXMLLayout createElement:[self->xmlDoc rootElement]];
        [self gic_addSubElement:childElement];
        tempcell = nil;
    }
    if(cell.layoutSubviewsSignlDisposable && !cell.layoutSubviewsSignlDisposable.isDisposed){
        [cell.layoutSubviewsSignlDisposable dispose];
    }
    UIView *v = [cell.contentView.subviews firstObject];
    @weakify(self)
    cell.layoutSubviewsSignlDisposable = [[v rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        CGFloat h = [v gic_calcuActualHeight];
        self.cellHeight = h;
    }];
    cell.gic_isAutoInheritDataModel = NO;
    cell.gic_DataContenxt = self.gic_DataContenxt;
    return cell;
}
@end
