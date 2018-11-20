//
//  GICCanvas+Beta.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/3.
//

#import "GICCanvas+Beta.h"
#import "GICCanvasPath.h"

@interface GICCanvas (){
    NSMutableArray<GICCanvasPath *> *paths;
}
@end

@implementation GICCanvas
+(NSString *)gic_elementName{
    return @"canvas";
}

+ (void)drawRect:(CGRect)bounds withParameters:(NSMutableArray<GICCanvasPath *> *)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for(GICCanvasPath *path in parameters){
        [path draw:ctx withBounds:bounds];
    }
}

-(id)init{
    self = [super init];
    self.opaque = NO;
    paths = [NSMutableArray array];
    return self;
}
-(void)layout{
    [super layout];
    [self setNeedsDisplay];
}
- (id<NSObject>)drawParametersForAsyncLayer:(_ASDisplayLayer *)layer{
    [paths sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 gic_ExtensionProperties].elementOrder > [obj2 gic_ExtensionProperties].elementOrder? NSOrderedDescending:NSOrderedAscending;
    }];
    return [paths copy];
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICCanvasPath class]]){
        [paths addObject:subElement];
        return subElement;
    }
    return [super gic_willAddAndPrepareSubElement:subElement];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:[GICCanvasPath gic_elementName]]){
        return [GICCanvasPath new];
    }
//    else if([element.name isEqualToString:[GICCanvasRectangle gic_elementName]]){
//        return [GICCanvasRectangle new];
//    }else if([element.name isEqualToString:[GICCanvasArc gic_elementName]]){
//        return [GICCanvasArc new];
//    }
    return [super gic_parseSubElementNotExist:element];
}

#pragma mark GICDisplayProtocol
-(void)gic_setNeedDisplay{
    if(self.nodeLoaded){
        [self setNeedsDisplay];
    }
}
@end
