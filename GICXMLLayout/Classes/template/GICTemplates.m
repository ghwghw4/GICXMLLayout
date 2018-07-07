//
//  GICTemplates.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICTemplates.h"

@implementation GICTemplates
+(NSString *)gic_elementName{
    return @"templates";
}

-(id)init{
    self = [super init];
    _templats = [NSMutableDictionary dictionary];
    return self;
}

-(void)gic_addSubElement:(GICTemplate *)subElement{
    if([subElement isKindOfClass:[GICTemplate class]]){
        [self.templats setValue:subElement forKey:subElement.name];
    }
}
@end
