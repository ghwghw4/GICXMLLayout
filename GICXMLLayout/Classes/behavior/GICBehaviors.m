//
//  GICBehaviors.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/12.
//

#import "GICBehaviors.h"

@implementation GICBehaviors
+(NSString *)gic_elementName{
    return @"behaviors";
}
-(id)init{
    self = [super init];
    _behaviors = [NSMutableArray array];
    return self;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICBehavior class]]){
        [self.behaviors addObject:subElement];
    }
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    Class c = [GICElementsCache classForBehaviorElementName:element.name];
    if(c){
        id obj = [c new];
        return obj;
    }
    return [super gic_parseSubElementNotExist:element];
}
@end
