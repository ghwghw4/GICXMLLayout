//
//  GICInpute.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/5.
//

#import <UIKit/UIKit.h>

@interface GICInputeView : ASEditableTextNode{
    NSMutableAttributedString *placeholdString;
    NSMutableAttributedString *textString;
    
    NSMutableDictionary *textAttributs;
    NSMutableDictionary *placeholdAttributs;
}
@end
