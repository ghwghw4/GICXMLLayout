//
//  GICNavbarButtons.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICNavbarButtons.h"

@implementation GICNavbarButtons

-(id)init{
    self = [super init];
    self.isHorizon = YES;
    [self->stackPanelPropertyDict setValue:@(4) forKey:@"spacing"];
    [self->stackPanelPropertyDict setValue:@(2) forKey:@"alignItems"];//水平居中
    self.frame = CGRectMake(0, 0, 1, 44);
    return self;
}

-(void)layout{
    [super layout];
    if(self.sizeChangedBlock){
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        ASLayout * layout = [self layoutThatFits:ASSizeRangeMake(CGSizeMake(0, 44), CGSizeMake(width, 44))];
        if(!CGSizeEqualToSize(self.frame.size, layout.size)){
            self.frame = CGRectMake(0, 0, layout.size.width, layout.size.height);
            self.sizeChangedBlock(layout.size);
        }
    }
}
@end
