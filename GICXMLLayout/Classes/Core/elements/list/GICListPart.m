//
//  GICListPart.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/5.
//

#import "GICListPart.h"

@implementation GICListPart
-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    self.automaticallyManagesSubnodes = YES;
    NSArray<ASDisplayNode *> *chilren = self.gic_displayNodes;
    [chilren enumerateObjectsUsingBlock:^(ASDisplayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.style.width.value == 0){
            obj.style.width = ASDimensionMake(constrainedSize.min.width);
        }
    }];
    return  [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:chilren];
}

-(void)layout{
    [super layout];
    if(self.sizeChangedBlock){
        CGFloat width = self.frame.size.width;
        ASLayout * layout = [self layoutThatFits:ASSizeRangeMake(CGSizeMake(width, 0), CGSizeMake(width, MAXFLOAT))];
        if(!CGSizeEqualToSize(self.frame.size, layout.size)){
            self.frame = CGRectMake(0, 0, width, layout.size.height);
            self.sizeChangedBlock(layout.size);
        }
    }
}
@end
