//
//  ASDisplayNode+GICExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNode+GICExtension.h"
#import "GICColorConverter.h"
#import "GICNumberConverter.h"
#import "GICLayoutUtils.h"

@implementation ASDisplayNode (GICExtension)
+(NSString *)gic_elementName{
    return nil;
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    NSMutableDictionary *mutDict=  [@{@"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
        [(ASDisplayNode *)target setBackgroundColor:value];
    }],
                                      @"dock-horizal":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
        ((ASLayoutElementExtensionProperties *)target.gic_ExtensionProperties).dockHorizalModel = (GICDockPanelHorizalModel)[value integerValue];
    }],
                                      @"dock-vertical":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
        ((ASLayoutElementExtensionProperties *)target.gic_ExtensionProperties).dockVerticalModel = (GICDockPanelVerticalModel)[value integerValue];
    }],
                                      } mutableCopy];
    [mutDict addEntriesFromDictionary:[GICLayoutUtils commonPropertyConverters]];
    return mutDict;
}



-(ASLayoutElementExtensionProperties *)gic_ExtensionProperties{
    ASLayoutElementExtensionProperties *v =objc_getAssociatedObject(self, "gic_ExtensionProperties");
    if(!v){
        v = [ASLayoutElementExtensionProperties new];
        objc_setAssociatedObject(self, "gic_ExtensionProperties", v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}


-(NSArray *)gic_subElements{
    return self.subnodes;
}

-(void)gic_addSubElement:(NSObject *)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        [self addSubnode:(ASDisplayNode *)subElement];
    }else{
        [super gic_addSubElement:subElement];
    }
}

-(NSObject *)gic_getSuperElement{
    UIView *force = self.gic_ExtensionProperties.foreSuperElement;
    if(force){
        return force;
    }
    return [self supernode];
}

-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
    for(id sub in subElements){
        if([sub isKindOfClass:[ASDisplayNode class]]  && [self.subnodes containsObject:sub]){
            [(ASDisplayNode *)sub removeFromSupernode];
        }
    }
}

-(void)gic_safeView:(void (^)(UIView *view))cb{
    dispatch_async(dispatch_get_main_queue(), ^{
        cb(self.view);
    });
}
@end
