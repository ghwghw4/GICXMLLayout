//
//  GICAnimations.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/13.
//

#import "GICAnimations.h"
#import "GICAnimation.h"

@implementation GICAnimations
+(NSString *)gic_elementName{
    return @"animations";
}
-(id)init{
    self = [super init];
    _animations = [NSMutableArray array];
    return self;
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICAnimation class]]){
        [(NSMutableArray *)self.animations addObject:subElement];
        return subElement;
    }else{
        NSAssert(NO, @"animations 只允许添加animation元素");
    }
    return nil;
}
@end
