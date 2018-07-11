////
////  UIView+LayoutView.m
////  GDataXMLNode_GIC
////
////  Created by 龚海伟 on 2018/7/2.
////
//
//#import "ASDisplayNode+LayoutView.h"
//#import "UIColor+Extension.h"
//#import "GDataXMLNode.h"
//#import "GICXMLLayout.h"
//#import "UIView+GICExtension.h"
//#import <objc/runtime.h>
//
//#import "GICColorConverter.h"
//#import "GICNumberConverter.h"
//#import "GICEdgeConverter.h"
//#import "GICStringConverter.h"
//#import "GICDataBinding.h"
//#import "NSObject+GICDataBinding.h"
//#import "GICStringConverter.h"
//
//@implementation ASDisplayNode (LayoutView)

//
//-(void)gic_addSubElement:(NSObject *)subElement{
//    if([subElement isKindOfClass:[ASDisplayNode class]]){
//        [self addSubnode:(ASDisplayNode *)subElement];
//    }else{
//        [super gic_addSubElement:subElement];
//    }
//}
//
//-(void)gic_LayoutSubView:(UIView *)subView{
////    UIEdgeInsets margin = subView.gic_ExtensionProperties.margin;
////    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_offset(margin.top);
////        make.left.mas_offset(margin.left);
////
////        if(subView.gic_ExtensionProperties.width > 0)
////            make.width.mas_equalTo(subView.gic_ExtensionProperties.width);
////        else
////            make.right.mas_offset(-margin.right);
////
////        if(subView.gic_ExtensionProperties.height > 0)
////            make.height.mas_equalTo(subView.gic_ExtensionProperties.height);
////        else
////            make.bottom.mas_offset(-margin.bottom);
////    }];
//}
//
//-(NSObject *)gic_getSuperElement{
//    UIView *force = self.gic_ExtensionProperties.foreSuperElement;
//    if(force){
//        return force;
//    }
//    return [self subnodes];
//}
//
//-(void)gic_removeSubElements:(NSArray<NSObject *> *)subElements{
//    for(id sub in subElements){
//        if([sub isKindOfClass:[ASDisplayNode class]]  && [self.subnodes containsObject:sub]){
//            [sub removeFromSuperview];
//        }
//    }
//}
//
////-(void)gic_elementParseCompelte{
////    [super gic_elementParseCompelte];
////}
//@end
