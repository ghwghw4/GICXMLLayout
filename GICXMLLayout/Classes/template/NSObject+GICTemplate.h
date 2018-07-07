//
//  NSObject+GICTemplate.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import <Foundation/Foundation.h>
#import "GICTemplates.h"

@interface NSObject (GICTemplate)
@property (nonatomic,strong)GICTemplates *gic_templates;

-(GICTemplate *)gic_getTemplateFromName:(NSString *)templateName;
@end
