//
//  GICInpute.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/18.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface GICInpute : ASDisplayNode<UITextFieldDelegate>{
    NSMutableAttributedString *placeholdString;
    NSMutableDictionary *placeholdAttributs;
}
@end
