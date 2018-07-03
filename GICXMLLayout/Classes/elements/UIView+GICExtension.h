//
//  UIView+GICExtension.h
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import <UIKit/UIKit.h>

@interface UIView (GICExtension)
@property (nonatomic,assign)CGFloat gic_Width;
@property (nonatomic,assign)CGFloat gic_Height;
@property (nonatomic,assign)UIEdgeInsets gic_margin;

@property (nonatomic,strong)NSString *gic_Name;

@property (nonatomic,assign)NSInteger gic_ZIndex;
@end
