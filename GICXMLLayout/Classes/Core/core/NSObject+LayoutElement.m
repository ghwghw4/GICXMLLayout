//
//  NSObject+LayoutView.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/3.
//

#import "NSObject+LayoutElement.h"
#import "GICXMLLayout.h"
#import "GICStringConverter.h"
#import "NSObject+GICDataBinding.h"
#import <objc/runtime.h>
#import "NSObject+GICTemplate.h"
#import "GICTemplateRef.h"
#import "GICDataContextConverter.h"
#import "GICElementsCache.h"
#import "NSObject+GICStyle.h"

#import "GICAnimations.h"
#import "NSObject+GICAnimation.h"


@implementation NSObject (LayoutElement)

-(GICNSObjectExtensionProperties *)gic_ExtensionProperties{
    GICNSObjectExtensionProperties *v =objc_getAssociatedObject(self, "gic_ExtensionProperties");
    if(!v){
        v = [GICNSObjectExtensionProperties new];
        objc_setAssociatedObject(self, "gic_ExtensionProperties", v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}

+(NSString *)gic_elementName{
    return nil;
}

+(instancetype)createElementWithXML:(GDataXMLElement *)xmlElement{
    return [[self alloc] init];
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"name":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 target.gic_ExtensionProperties.name = value;
             } withGetter:^id(id target) {
                 return [target gic_ExtensionProperties].name;
             }],
             @"data-path":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [target setGic_dataPathKey:value];
             } withGetter:^id(id target) {
                 return [target gic_dataPathKey];
             }],
             @"data-context":[[GICDataContextConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 target.gic_ExtensionProperties.tempDataContext = value;
             } withGetter:^id(id target) {
                 return [target gic_self_dataContext];
             }]
             };;
}

-(void)gic_parseSubElements:(NSArray<GDataXMLElement *> *)children{
    NSInteger order = 0;
    for(GDataXMLElement *child in children){
        NSObject *childElement = [NSObject gic_createElement:child withSuperElement:self];
        if(childElement == nil)
            continue;
        childElement.gic_ExtensionProperties.elementOrder = order;
        [self gic_addSubElement:childElement];
        order++;
    }
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    return nil;
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if ([subElement isKindOfClass:[GICBehavior class]]){//如果是指令，那么交给指令自己执行
        [self gic_addBehavior:(GICBehavior *)subElement];
    }else if ([subElement isKindOfClass:[GICTemplates class]]){
        GICTemplates *ts = (GICTemplates *)subElement;
        if(self.gic_templates){
            [self.gic_templates.templats addEntriesFromDictionary:ts.templats];
        }else{
            self.gic_templates = ts;
        }
        // 将模板加入临时上下文中
        [[[GICXMLParserContext currentInstance] currentTemplates] addEntriesFromDictionary:ts.templats];
    }else if ([subElement isKindOfClass:[GICTemplateRef class]]){
        // 模板引用
        GICTemplateRef *tr = (GICTemplateRef *)subElement;
        // 这里先设置模板的数据源的目的就是为了在解析模板之前，让模板中绑定的属性生效
        if(![tr gic_self_dataContext]){
            tr.gic_DataContext = self.gic_DataContext;
        }
        NSObject *el = [tr parseTemplateFromTarget:self];
        el.gic_isAutoInheritDataModel = tr.gic_isAutoInheritDataModel;
        el.gic_DataContext = tr.gic_DataContext;
        el.gic_ExtensionProperties.elementOrder = tr.gic_ExtensionProperties.elementOrder;
        return [self gic_willAddAndPrepareSubElement:el];
    }else if ([subElement isKindOfClass:[GICBehaviors class]]){ //行为
        for(GICBehavior *b in ((GICBehaviors *)subElement).behaviors){
            b.gic_ExtensionProperties.superElement = self;
            [self gic_addBehavior:b];
        }
    }else if ([subElement isKindOfClass:[GICStyle class]]){ // 样式
        self.gic_style = (GICStyle *)subElement;
    }else if ([subElement isKindOfClass:[GICAnimations class]]){ //添加动画
        for(GICAnimation *a in ((GICAnimations *)subElement).animations){
            a.gic_ExtensionProperties.superElement = self;
            [self gic_addAnimation:a];
        }
        return subElement;
    }else{
        return nil;
    }
    return subElement;
}

-(id)gic_addSubElement:(id)subElement{
    id obj = [self gic_willAddAndPrepareSubElement:subElement];
    if(obj && [obj gic_isAutoCacheElement]){
        [[self gic_ExtensionProperties] addSubElement:obj];
    }
    return obj;
}

-(id)gic_insertSubElement:(id)subElement atIndex:(NSInteger)index{
    id obj = [self gic_willAddAndPrepareSubElement:subElement];
    // TODO:这里面暂时先直接以addSubElement 来添加，因为目前的架构在解析的时候并不会将子元素严格按照XML文件中的顺序添加
    // 后面一并修改架构，并且移除  gic_isAutoCacheElement，然后改为 insertElement添加，确保gic_ExtensionProperties中的元素跟XML中的一致
    ((NSObject *)subElement).gic_ExtensionProperties.elementOrder = index;
    [[self gic_ExtensionProperties] addSubElement:subElement];
    return obj;
}

-(NSInteger)gic_indexOfSubElement:(id)subElement{
    return [[self gic_ExtensionProperties] indexOfSubElement:subElement];
}


-(void)gic_beginParseElement:(GDataXMLElement *)element withSuperElement:(id)superElment{
    [self gic_ExtensionProperties].superElement = superElment;
    [self gic_parseAttributes:element];
    if([self gic_isAutoCacheElement]){
        [[superElment gic_ExtensionProperties] addSubElement:self];
    }
    // 解析子元素
    if([self respondsToSelector:@selector(gic_parseSubElements:)]){
        NSArray *children = element.children;
        if(children.count>0 && [children[0] isKindOfClass:[GDataXMLElement class]]){// 添加后面这个判断主要是为了解决某些标签在有结束标签的时候添加了换行，有可能会出现解析出错。
            // 检查是否支持单个子元素
            if([self respondsToSelector:@selector(gic_parseOnlyOneSubElement)] && [(id)self gic_parseOnlyOneSubElement]){
                NSAssert1(children.count <= 1, @"%@只支持单个子元素", element.name);
                if(children.count!=1){
                    return;
                }
            }
            [(id)self gic_parseSubElements:element.children];
        }
    }
    [self performSelector:@selector(_gic_parseElementCompelete)];
}

-(void)gic_parseAttributes:(GDataXMLElement *)element{
    // convert attributes
    NSMutableDictionary<NSString *, NSString *> *attributeDict=[self gic_mergeStyles:element];
    NSDictionary *ps = [GICElementsCache classAttributs:[self class]];
    for(NSString *key in attributeDict.allKeys){
        NSString *value = [attributeDict objectForKey:key];
        GICAttributeValueConverter *converter = [ps objectForKey:key];
        if(converter){
            if([value hasPrefix:@"{{"] && [value hasSuffix:@"}}"]){
                NSString *expression = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{} "]];
                GICDataBinding *binding = [GICDataBinding createBindingFromExpression:expression];
                binding.attributeValueConverter = converter;
                binding.target = self;
                binding.attributeName = key;
                [self gic_addBinding:binding];
                continue;
            }
            converter.propertySetter(self, [converter convert:value]);
        }
    }
}

-(void)_gic_parseElementCompelete{
    for(GICBehavior *b in [self.gic_Behaviors.behaviors copy]){
        [b attachTo:self];
    }
    id temp = self.gic_ExtensionProperties.tempDataContext;
    if(temp){
        self.gic_DataContext = temp;
        self.gic_ExtensionProperties.tempDataContext = nil;
        self.gic_isAutoInheritDataModel = NO;
    }
    [self gic_parseElementCompelete];
}

-(void)gic_parseElementCompelete {}

- (BOOL)gic_parseOnlyOneSubElement {
    return NO;
}


-(id)gic_getSuperElement{
    return self.gic_ExtensionProperties.superElement;
}

-(void)gic_removeFromSuperElement{
    [[self gic_getSuperElement] gic_removeSubElements:@[self]];
}

-(NSArray *)gic_subElements{
    return [self.gic_ExtensionProperties.subElements copy];
}
-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    [self.gic_ExtensionProperties removeSubElements:subElements];
}

-(BOOL)gic_isAutoCacheElement{
    return YES;
}

+(NSObject *)gic_createElement:(GDataXMLElement *)element withSuperElement:(id)superElement{
    @autoreleasepool{
        NSString *elementName = element.name;
        Class c = [GICElementsCache classForElementName:elementName];
        if(c){
            NSObject *v = [c createElementWithXML:element];
            [v gic_beginParseElement:element withSuperElement:superElement];
            return v;
        }else{
            id v = [superElement gic_parseSubElementNotExist:element];
            [v gic_beginParseElement:element withSuperElement:superElement];
            return v;
        }
        return nil;
    }
}
@end
