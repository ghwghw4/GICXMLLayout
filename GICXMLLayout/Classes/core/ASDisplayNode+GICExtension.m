//
//  ASDisplayNode+GICExtension.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "ASDisplayNode+GICExtension.h"

@implementation ASDisplayNode (GICExtension)
+(NSString *)gic_elementName{
    return nil;
}

-(GICDisplayNodeExtensionProperties *)gic_ExtensionProperties{
    GICDisplayNodeExtensionProperties *v =objc_getAssociatedObject(self, "gic_ExtensionProperties");
    if(!v){
        v = [GICDisplayNodeExtensionProperties new];
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
