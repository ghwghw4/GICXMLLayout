//
//  GICTemplateRef.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/7.
//

#import "GICTemplateRef.h"
#import "GICStringConverter.h"
#import "NSObject+GICTemplate.h"
#import "NSObject+GICDataContext.h"
#import "NSObject+GICEvent.h"

@implementation GICTemplateRef
+(NSString *)gic_elementName{
    return @"template-ref";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"t-name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICTemplateRef *)target setTemplateName:value];
             }],
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

-(void)gic_parseAttributes:(GDataXMLElement *)element{
    self.templateName = [[element attributeForName:@"t-name"] stringValue];
}

-(void)gic_parseElement:(GDataXMLElement *)element{
    selfElement = element;
    [super gic_parseElement:element];
}

-(NSObject *)parseTemplate:(GICTemplate *)t{
    NSObject *childElement = nil;
    NSString *xmlDocString = nil;
    if(slotsXmlDocMap && slotsXmlDocMap.count>0){
        // 如果有slot，那么久开始执行替换slot流程
        tempConvertSlotMap = [NSMutableDictionary dictionary];
        [self findSlotElement:[t.xmlDoc rootElement]];
        if(tempConvertSlotMap.allKeys.count>0){
            NSString *xmlString = [t.xmlDoc.rootElement XMLString];
            for(NSString *slotName in tempConvertSlotMap.allKeys){
                xmlString = [xmlString stringByReplacingOccurrencesOfString:[tempConvertSlotMap objectForKey:slotName] withString:[slotsXmlDocMap objectForKey:slotName]];
            }
            xmlDocString = xmlString;
        }
        tempConvertSlotMap = nil;
    }else{
        xmlDocString = [[t.xmlDoc rootElement] XMLString];
    }
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlDocString options:0 error:nil];
    for(GDataXMLNode *node in selfElement.attributes){
        [xmlDoc.rootElement addAttribute:node];
    }
    childElement = [GICXMLLayout createElement:[xmlDoc rootElement]];
    
//    if(self.gic_dataPathKey && !childElement.gic_dataPathKey){
//        childElement.gic_dataPathKey = self.gic_dataPathKey;
//    }
//
//    if([self gic_self_dataContext]){
//         childElement.gic_DataContenxt = [self gic_self_dataContext];
//    }
//    childElement.gic_isAutoInheritDataModel = self.gic_isAutoInheritDataModel;
    
    
    
    
    
    
    
    
    
    
//    // 自动继承事件
//    if(self.gic_events.count>0){
//        for(GICEvent *e in self.gic_events){
//            [childElement gic_event_addEvent:e];
//            [e attachTo:childElement];
//        }
//    }
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
    self->target = target;
    GICTemplate *t = [target gic_getTemplateFromName:self.templateName];
    if(t){
        return [self parseTemplate:t];
    }
    return nil;
}
@end
