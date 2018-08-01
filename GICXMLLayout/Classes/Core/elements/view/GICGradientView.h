//
//  GICGradientView.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/14.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface GICGradientView : ASImageNode
@property (nonatomic,strong)NSArray *colors;
@property (nonatomic,strong)NSArray *locations;
@property (nonatomic,assign)CGPoint start;
@property (nonatomic,assign)CGPoint end;
@end
