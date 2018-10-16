//
//  GICListFooter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/28.
//

#import "GICListFooter.h"

@implementation GICListFooter
+(NSString *)gic_elementName{
    return @"footer";
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    self.automaticallyManagesSubnodes = YES;
    NSArray<ASDisplayNode *> *chilren = self.gic_displayNodes;
    [chilren enumerateObjectsUsingBlock:^(ASDisplayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.style.width.value == 0){
            obj.style.width = ASDimensionMake(constrainedSize.min.width);
        }
    }];
    ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:chilren];
    return absoluteSpec;
}
@end
