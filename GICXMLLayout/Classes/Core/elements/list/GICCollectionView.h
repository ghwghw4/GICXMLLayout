//
//  GICCollectionView.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/26.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface GICCollectionView : ASCollectionNode
@property (nonatomic,assign)UITableViewCellSeparatorStyle separatorStyle;
- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate layoutFacilitator:(id<ASCollectionViewLayoutFacilitatorProtocol>)layoutFacilitator;

-(void)onItemAddedInSection:(NSDictionary *)itemInfo;

+(NSInteger)columnSpanFromElement:(id)element;
@end
