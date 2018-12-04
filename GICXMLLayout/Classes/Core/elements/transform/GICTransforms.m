//
//  GICTransforms.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/12/3.
//

#import "GICTransforms.h"
#import "GICTransformTranslate.h"
#import "GICTransformScale.h"
#import "GICTransformRotate.h"

@implementation GICTransforms
static NSDictionary<NSString *,Class> *supportElementParts = nil;

+(void)initialize{
    supportElementParts = @{
                            [GICTransformTranslate gic_elementName]:[GICTransformTranslate class],
                            [GICTransformScale gic_elementName]:[GICTransformScale class],
                            [GICTransformRotate gic_elementName]:[GICTransformRotate class],
                            };
}

+(NSString *)gic_elementName{
    return @"transforms";
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    [self gic_setNeedDisplay];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    Class klass = [supportElementParts objectForKey:element.name];
    if(klass){
        return [klass new];
    }
    return [super gic_parseSubElementNotExist:element];
}

#pragma mark GICDisplayProtocol
-(void)gic_setNeedDisplay{
    if([self.target isKindOfClass:[ASDisplayNode class]]){
        CATransform3D t = CATransform3DIdentity;
        for(id tmp in [self gic_subElements]){
            if([tmp isKindOfClass:[GICTransform class]]){
                t = CATransform3DConcat(t, [(GICTransform *)tmp makeTransform]);
            }
        }
        [(ASDisplayNode *)self.target setTransform:t];
    }
}
@end
