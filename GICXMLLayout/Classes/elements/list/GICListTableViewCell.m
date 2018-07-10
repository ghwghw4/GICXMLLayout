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
    self =[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listItem.identifyString];
//    _listItem = listItem;
//    [self createContentView:listItem.xmlDoc];
    self.listItem = listItem;
    return self;
}

-(void)gic_addSubElement:(NSObject *)childElement{
    // 必须是panel才能被加入节点
    if([childElement isKindOfClass:[GICPanel class]]){
        [self.contentView addSubview:(GICPanel *)childElement];
        [self.contentView gic_LayoutSubView:(GICPanel *)childElement];
    }else{
        [super gic_addSubElement:childElement];
    }
}

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
    self.selectionStyle = listItem.selectionStyle;
    
    
    if(layoutSubviewsSignlDisposable && !layoutSubviewsSignlDisposable.isDisposed){
        [layoutSubviewsSignlDisposable dispose];
    }
    
    if(self.contentView.subviews.count == 0){
        [self createContentView:listItem.xmlDoc];
    }
    
    UIView *v = [self.contentView.subviews firstObject];
    layoutSubviewsSignlDisposable = [[v rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        CGFloat h = [v gic_calcuActualHeight];
        listItem.cellHeight = h;
    }];
    self.gic_isAutoInheritDataModel = NO;
    [self gic_updateDataContext:listItem.gic_DataContenxt];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if(self.listItem.itemSelectEvent && selected){
        [self.listItem.itemSelectEvent.eventSubject sendNext:@(selected)];
    }
}

@end
