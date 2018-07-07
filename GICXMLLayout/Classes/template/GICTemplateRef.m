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

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count>0){
        slotsXmlDocMap = [NSMutableDictionary dictionary];
        // 筛选出有slot-name 的子节点
        for(GDataXMLElement *node in children){
            NSString *slotName = [[node attributeForName:@"slot-name"] stringValue];
            if(slotName){
                [slotsXmlDocMap setValue:[node XMLString] forKey:slotName];
            }
        }
    }
}


-(NSObject *)parseTemplate:(GICTemplate *)t{
    if(slotsXmlDocMap && slotsXmlDocMap.count>0){
        // 如果有slot，那么久开始执行替换slot流程
        tempConvertSlotMap = [NSMutableDictionary dictionary];
        [self findSlotElement:[t.xmlDoc rootElement]];
        if(tempConvertSlotMap.allKeys.count>0){
            NSString *xmlString = [t.xmlDoc.rootElement XMLString];
            for(NSString *slotName in tempConvertSlotMap.allKeys){
                xmlString = [xmlString stringByReplacingOccurrencesOfString:[tempConvertSlotMap objectForKey:slotName] withString:[slotsXmlDocMap objectForKey:slotName]];
            }
            tempConvertSlotMap = nil;
            GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
            return  [GICXMLLayout createElement:[xmlDoc rootElement]];
        }
        tempConvertSlotMap = nil;
    }
    
    NSObject *childElement = [GICXMLLayout createElement:[t.xmlDoc rootElement]];
    return childElement;
}

-(void)findSlotElement:(GDataXMLElement *)element{
    for(GDataXMLElement *child in element.children){
        if([child.name isEqualToString:@"template-slot"]){
            NSString *slotName = [[child attributeForName:@"slot-name"] stringValue];
            if([slotsXmlDocMap.allKeys containsObject:slotName]){
                [tempConvertSlotMap setValue:child.XMLString forKey:slotName];
            }
        }else{
            [self findSlotElement:child];
        }
    }
}

-(NSObject *)parseTemplateFromTarget:(id)target{
    GICTemplate *t = [target gic_getTemplateFromName:self.templateName];
    if(t){
        return [self parseTemplate:t];
    }
    return nil;
}
@end
