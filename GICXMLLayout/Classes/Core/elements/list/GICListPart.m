//
//  GICListPart.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/5.
//

#import "GICListPart.h"

@implementation GICListPart
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
