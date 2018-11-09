//
//  GICDirectiveIf.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/24.
//

#import "GICDirectiveIf.h"
#import "GICBoolConverter.h"

@implementation GICDirectiveIf{
    /**
     if指令的数据源有点特殊。主要是考虑了data-path的存在。比如：
     if 指令的父节点使用了data-path，当父节点数据源更新的时候能准确的获取data-path的数据。但是如果在if中直接使用 this.dataContext 来获取数据源，那么获取到的数据源其实是 除去data-path的原数据，这样的话两种数据就不一致了。因此这里将data-path后的数据缓存下来再做处理。
     **/
    id dataContext;
}
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
            addedElement = [self.target gic_insertSubElement:childElement elementOrder:self.gic_ExtensionProperties.elementOrder];
            [addedElement gic_updateDataContext:dataContext];
        }
    }else{
        if(addedElement){
            [self.target gic_removeSubElements:@[addedElement]];
        }
        
        if(self->elseXmlDoc && !self->elseElement){
            NSObject *childElement = [NSObject gic_createElement:[self->elseXmlDoc rootElement] withSuperElement:self.target];
            elseElement = [self.target gic_insertSubElement:childElement elementOrder:self.gic_ExtensionProperties.elementOrder];
            [elseElement gic_updateDataContext:dataContext];
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

-(void)gic_updateDataContext:(id)superDataContenxt{
    [super gic_updateDataContext:superDataContenxt];
    dataContext = superDataContenxt;
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
