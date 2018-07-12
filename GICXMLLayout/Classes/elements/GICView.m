//
//  GICView.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/12.
//

#import "GICView.h"

@implementation GICView

+(NSString *)gic_elementName{
    return @"view";
}

-(BOOL)gic_parseOnlyOneSubElement{
    return true;
}

-(NSArray *)gic_subElements{
    if(panel)
        return @[panel];
    return nil;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICPanel class]]){
        panel = subElement;
    }else{
        [super gic_addSubElement:subElement];
    }
}

//-(void)gic_elementParseCompelte{
//    [super gic_elementParseCompelte];
//    panel.superDisplayNode = self;
//}

-(id)init{
    self =[super init];
    self.automaticallyManagesSubnodes = YES;
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    if(panel==nil){
        ASStackLayoutSpec *stackLayoutSpec = [[ASStackLayoutSpec alloc] init];
        stackLayoutSpec.direction = ASStackLayoutDirectionVertical;
        return stackLayoutSpec;
    }
    return [panel layoutSpecThatFits:constrainedSize];
}
@end
