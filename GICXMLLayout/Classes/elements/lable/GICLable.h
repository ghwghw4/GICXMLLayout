//
//  GICLable.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>

@interface GICLable : UILabel<LayoutElementProtocol>{
    GDataXMLElement *xmlDoc;
    NSMutableArray<NSMutableAttributedString *> *attbuteStringArray;
//    id<RACSubscriber> reloadStringSubscriber;
}

@end
