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

-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICBehavior class]]){
        [self.behaviors addObject:subElement];
        return subElement;
    }
    return nil;
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

-(GICBehavior *)findFirstWithBehaviorClass:(Class)behaviorType{
    for(GICBehavior *b in self.behaviors){
        if(b.class == behaviorType){
            return b;
        }
    }
    return nil;
}

-(GICBehavior *)findWithBehaviorName:(NSString *)behaviorName{
    for(GICBehavior *b in self.behaviors){
        if([b.name isEqualToString:behaviorName]){
            return b;
        }
    }
    return nil;
}
@end
