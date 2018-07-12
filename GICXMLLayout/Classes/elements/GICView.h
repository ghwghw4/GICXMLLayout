//
//  GICView.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/12.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "GICPanel.h"
@interface GICView : ASDisplayNode<LayoutElementProtocol>{
    GICPanel *panel;
}
@end
