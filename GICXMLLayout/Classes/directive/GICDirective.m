//
//  GICDirective.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/6.
//

#import "GICDirective.h"
@implementation GICDirective
+(NSString *)gic_elementName{
    return nil;
}

-(void)attachTo:(id)target{
    self.target = target;
}

-(NSObject *)gic_getSuperElement{
    return self.target;
}
@end
