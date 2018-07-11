//
//  GICListTableViewCell.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICListTableViewCell.h"
#import "GICPanel.h"

@implementation NSAttributedString (Additions)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string fontSize:(CGFloat)size color:(nullable UIColor *)color
{
    if (string == nil) {
        return nil;
    }
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: color ? : [UIColor blackColor],
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:size]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
    
    return attributedString;
}

@end

@implementation GICListTableViewCell

-(id)initWithListItem:(GICListItem *)listItem{
    self =[super init];
    self.listItem = listItem;
    self.automaticallyManagesSubnodes = YES;
    return self;
}

-(void)gic_addSubElement:(NSObject *)childElement{
    // 必须是panel才能被加入节点
    if([childElement isKindOfClass:[ASDisplayNode class]]){
        [self addSubnode:(ASDisplayNode *)childElement];
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
    
    if(self.subnodes.count == 0){
        [self createContentView:listItem.xmlDoc];
    }

    self.gic_isAutoInheritDataModel = NO;
    [self gic_updateDataContext:listItem.gic_DataContenxt];
}
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    return self;
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//    if(self.listItem.itemSelectEvent && selected){
//        [self.listItem.itemSelectEvent.eventSubject sendNext:@(selected)];
//    }
//}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(self.listItem.itemSelectEvent && selected){
        [self.listItem.itemSelectEvent.eventSubject sendNext:@(selected)];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:self.subnodes.firstObject];
}
@end
