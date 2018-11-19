//
//  GICDirectiveIf.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/24.
//

#import "GICDirectiveIf.h"
#import "GICBoolConverter.h"

@implementation GICDirectiveIf
+(NSString *)gic_elementName{
    return @"if";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return  @{
              @"condition":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICDirectiveIf *)target setCondition:[value boolValue]];
              }],
              };;
}

-(id)init{
    self = [super init];
    _condition = -1;//默认什么都不显示。可以使用枚举实现。
    return self;
}

-(void)updateCondition{
    if(self.condition == -1)
        return;
    if(self.condition){
        if(elseElement){
            [self.target gic_removeSubElements:@[elseElement]];
        }
        
        if(!addedElement){
            NSObject *childElement = [NSObject gic_createElement:[self->xmlDoc rootElement] withSuperElement:self.target];
            addedElement = [self.target gic_insertSubElement:childElement atIndex:[self.gic_ExtensionProperties elementOrder]];
            [addedElement gic_updateDataContext:self.gic_DataContext];
        }
    }else{
        if(addedElement){
            [self.target gic_removeSubElements:@[addedElement]];
        }
        
        if(self->elseXmlDoc && !self->elseElement){
            NSObject *childElement = [NSObject gic_createElement:[self->elseXmlDoc rootElement] withSuperElement:self.target];
            elseElement = [self.target gic_insertSubElement:childElement atIndex:[self.gic_ExtensionProperties elementOrder]];
            [elseElement gic_updateDataContext:self.gic_DataContext];
        }
    }
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    if(children.count<=2){//最多两个子元素
        for(GDataXMLElement *child in children){
            if([child.name isEqualToString:@"else"]){
                self->elseXmlDoc = [[GDataXMLDocument alloc] initWithXMLString:[(GDataXMLElement *)child.children[0] XMLString] options:0 error:nil];
            }else{
                self->xmlDoc =  [[GDataXMLDocument alloc] initWithXMLString:child.XMLString options:0 error:nil];
            }
        }
    }else{
        NSAssert(NO, @"if 最多只能包含两个子元素，并且在两个子元素的情况下，必须包含一个else子元素");
    }
}

-(BOOL)gic_parseOnlyOneSubElement{
    return NO;
}

-(void)setCondition:(int8_t)condition{
    _condition = condition;
    [self updateCondition];
}

-(void)attachTo:(id)target{
    [super attachTo:target];
    [self updateCondition];
}
@end
