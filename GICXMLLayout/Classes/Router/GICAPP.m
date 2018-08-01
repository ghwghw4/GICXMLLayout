//
//  GICAPP.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import "GICAPP.h"

@implementation GICAPP
+(NSString *)gic_elementName{
    return @"app";
}
-(id)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[UIViewController class]]){
        self.rootViewController = subElement;
        return subElement;
    }
    return [super gic_addSubElement:subElement];
}
@end

