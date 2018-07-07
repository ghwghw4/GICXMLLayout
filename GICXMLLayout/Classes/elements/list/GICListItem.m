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

-(void)gic_addSubElement:(NSObject *)childElement{
    if([childElement isKindOfClass:[GICPanel class]]){
        _identifyString = [GICUtils uuidString];
        
        @weakify(self)
        [[childElement rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            CGFloat h = [childElement gic_calcuActualHeight];
            self.cellHeight = h;
        }];
        [self.contentView addSubview:childElement];
        [self.contentView gic_LayoutSubView:childElement];
    }else{
//        NSAssert(false, @"list-item 只支持 panel作为子元素");[
        [super gic_addSubElement:childElement];
    }
}

//-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
//    if(children.count==1){
//        GICPanel *childElement = (GICPanel *)[GICXMLLayout createElement:children[0]];
//        if([childElement isKindOfClass:[GICPanel class]]){
//            _identifyString = [GICUtils uuidString];
//
//            @weakify(self)
//            [[childElement rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
//                @strongify(self)
//                CGFloat h = [childElement gic_calcuActualHeight];
//                self.cellHeight = h;
//            }];
//            [self.contentView addSubview:childElement];
//            [self.contentView gic_LayoutSubView:childElement];
//        }else{
//            NSAssert(false, @"list-item 只支持 panel作为子元素");
//        }
//    }
//}
@end
