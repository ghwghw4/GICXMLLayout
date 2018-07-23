//
//  GICLable.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>

@interface GICLable : ASTextNode{
    GDataXMLElement *xmlDoc;
    NSMutableArray<NSMutableAttributedString *> *attbuteStringArray;
    NSMutableDictionary<NSString *,id> *attributes;
    NSMutableAttributedString *mutAttString;
    NSMutableParagraphStyle *paragraphStyle;
}

@end
