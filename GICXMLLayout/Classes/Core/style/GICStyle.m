//
//  GICStyle.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/31.
//

#import "GICStyle.h"
#import "GICTemplates.h"
#import "GICStringConverter.h"
#import "GICURLConverter.h"

static NSString * const GICSTyleNameString =  @"style-name";

@implementation GICStyle
+(NSString *)gic_elementName{
    return @"style";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"path":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICStyle *)target setPath:value];
             }],
             };;
}

-(id)init{
    self = [super init];
    styleForNamesDict = [NSMutableDictionary dictionary];
    styleForElementsDict = [NSMutableDictionary dictionary];
    return self;
}

-(void)setPath:(NSString *)path{
    _path = path;
    NSData *xmlData= [GICXMLLayout loadDataFromPath:path];
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    if (xmlDocument) {
        GICStyle *style = (GICStyle *)[NSObject gic_createElement:xmlDocument.rootElement withSuperElement:[self gic_getSuperElement]];
        if(style && [style isKindOfClass:[GICStyle class]]){
            [self->styleForNamesDict addEntriesFromDictionary:style->styleForNamesDict];
            [self->styleForElementsDict addEntriesFromDictionary:style->styleForElementsDict];
        }
    }
}

-(BOOL)gic_isAutoCacheElement{
    return NO;
}

-(id)gic_addSubElement:(id)subElement{
    if ([subElement isKindOfClass:[GICTemplates class]]){
         [[self gic_getSuperElement] gic_addSubElement:subElement];
        return nil;
    }
    return nil;
}


-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    for(GDataXMLElement *child in children){
        NSString *elementName = [child name];
        if([elementName isEqualToString:[GICTemplates gic_elementName]]){
            [super gic_parseSubElements:@[child]];
        }else{
            // 解析样式
            NSMutableDictionary<NSString *, NSString *> *attributeDict=[NSMutableDictionary dictionary];
            [child.attributes enumerateObjectsUsingBlock:^(GDataXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [attributeDict setValue:[obj stringValueOrginal] forKey:[obj name]];
            }];
            NSString *styleName = [attributeDict objectForKey:GICSTyleNameString];
            if(styleName){
                [attributeDict removeObjectForKey:GICSTyleNameString];
                if(attributeDict.count>0)
                    [styleForNamesDict setObject:attributeDict forKey:styleName];
            }else{
                if(attributeDict.count>0)
                    [styleForElementsDict setObject:attributeDict forKey:elementName];
            }
        }
    }
}

-(NSDictionary<NSString *,NSString *>*)styleFromStyleName:(NSString *)styleName{
    return [styleForNamesDict objectForKey:styleName];
}

-(NSDictionary<NSString *,NSString *>*)styleFromElementName:(NSString *)elementName{
    return [styleForElementsDict objectForKey:elementName];
}
@end
