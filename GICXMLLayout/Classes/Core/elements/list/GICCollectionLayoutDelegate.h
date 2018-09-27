//
//  GICCollectionLayoutDelegate.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/26.
//

#import <Foundation/Foundation.h>
// 如果修改了如下属性的值，那么需要对collectionview reloaddata
@interface GICCollectionLayoutInfo:NSObject
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
@property (nonatomic, assign) UIEdgeInsets interItemSpacing;

// 是否自动更新LayoutHieght，如果设置了ture，那么就会将全部内容显示出来。并且改变容器的高度。这种方式主要是在内嵌一个grid的情况下适用
@property (nonatomic, assign) BOOL autoChangeLayoutHieght;

- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                           headerHeight:(CGFloat)headerHeight
                          columnSpacing:(CGFloat)columnSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                       interItemSpacing:(UIEdgeInsets)interItemSpacing NS_DESIGNATED_INITIALIZER;

- (instancetype)init __unavailable;
@end


@interface GICCollectionLayoutDelegate:NSObject <ASCollectionLayoutDelegate>
@property (nonatomic,strong,readonly)GICCollectionLayoutInfo *layoutInfo;
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns headerHeight:(CGFloat)headerHeight;
@property (nonatomic,weak)ASCollectionNode *target;
@end
