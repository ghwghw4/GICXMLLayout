//
//  NSObject+GICTemplate.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "NSObject+GICTemplate.h"
#import <objc/runtime.h>

@implementation NSObject (GICTemplate)
-(void)setGic_templates:(GICTemplates *)gic_templates{
    objc_setAssociatedObject(self, "gic_templates", gic_templates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(GICTemplates *)gic_templates{
    return objc_getAssociatedObject(self, "gic_templates");
}

-(GICTemplate *)gic_getTemplateFromName:(NSString *)templateName{
    GICTemplate *t = [[self.gic_templates templats] objectForKey:templateName];
    if(!t)
        t = [[[GICXMLParserContext currentInstance] currentTemplates] objectForKey:templateName];
    if(t){
        return t;
    }
    NSObject *superElement= [self gic_getSuperElement];
    if(superElement){
        return [superElement gic_getTemplateFromName:templateName];
    }
    return nil;
}
@end
