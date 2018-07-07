//
//  GICTemplateRef.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICTemplateRef.h"
#import "GICStringConverter.h"
#import "NSObject+GICTemplate.h"

@implementation GICTemplateRef
+(NSString *)gic_elementName{
    return @"template-ref";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"t-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICTemplateRef *)target setTemplateName:value];
             }]
             };;
}

-(void)gic_elementParseCompelte{
    
}

-(NSObject *)parseTemplate:(GICTemplate *)t{
    return [t createElement];
}

-(NSObject *)parseTemplateFromTarget:(id)target{
    GICTemplate *t = [target gic_getTemplateFromName:self.templateName];
    if(t){
        return [self parseTemplate:t];
    }
    return nil;
}
@end
