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

@implementation GICTemplateRef
+(NSString *)gic_elementName{
    return @"template-ref";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
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

-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    selfElement = [[GDataXMLDocument alloc] initWithXMLString:element.XMLString options:0 error:nil];
    [super gic_beginParseElement:element withSuperElement:superElment];
}

-(NSObject *)parseTemplate:(GICTemplate *)t{
    NSObject *childElement = nil;
    NSString *xmlDocString = nil;
    if(slotsXmlDocMap && slotsXmlDocMap.count>0){
        // 如果有slot，那么久开始执行替换slot流程
        tempConvertSlotMap = [NSMutableDictionary dictionary];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:t.xmlDocString options:0 error:nil];
        [self findSlotElement:xmlDoc.rootElement];
        if(tempConvertSlotMap.allKeys.count>0){
            NSString *xmlString = t.xmlDocString;
            for(NSString *slotName in tempConvertSlotMap.allKeys){
                xmlString = [xmlString stringByReplacingOccurrencesOfString:[tempConvertSlotMap objectForKey:slotName] withString:[slotsXmlDocMap objectForKey:slotName]];
            }
            xmlDocString = xmlString;
        }else{
            xmlDocString = t.xmlDocString;
        }
        tempConvertSlotMap = nil;
    }else{
        xmlDocString = t.xmlDocString;
    }

    //合并template-ref的属性，template-ref 中定义的属性优先级高于template中定义的属性
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlDocString options:0 error:nil];
    for(GDataXMLNode *node in selfElement.rootElement.attributes){
        NSString *nodeName = node.name;
        if(![nodeName isEqualToString:@"t-name"]){//t-name 属性允许重复
            GDataXMLNode *exitNode = [xmlDoc.rootElement attributeForName:node.name];
            if(exitNode){
                [xmlDoc.rootElement removeChild:exitNode];
            }
        }
        [xmlDoc.rootElement addAttribute:node];
    }
    childElement = [NSObject gic_createElement:[xmlDoc rootElement] withSuperElement:target];
    return childElement;
}

-(void)findSlotElement:(GDataXMLElement *)element{
    for(GDataXMLElement *child in element.children){
        if([child.name isEqualToString:@"template-slot"]){
            NSString *slotName = [[child attributeForName:@"slot-name"] stringValue];
            if([slotsXmlDocMap.allKeys containsObject:slotName]){
                [tempConvertSlotMap setValue:child.XMLString forKey:slotName];
                // 合并template-slot 的属性。template-ref 中定义的属性优先级高于template-slot中定义的属性。
                NSArray *attributes = child.attributes;
                if(attributes.count>1){
                    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:[slotsXmlDocMap objectForKey:slotName] options:0 error:nil];
                    for(GDataXMLNode *att in attributes){
                        if(![att.name isEqualToString:@"slot-name"]){
                            GDataXMLNode *exitNode = [xmlDoc.rootElement attributeForName:att.name];
                            if(!exitNode){
                                [xmlDoc.rootElement addChild:att];
                            }
                        }
                    }
                    [slotsXmlDocMap setValue:[xmlDoc.rootElement XMLString] forKey:slotName];
                }
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

-(BOOL)gic_isAutoCacheElement{
    return NO;
}
@end
