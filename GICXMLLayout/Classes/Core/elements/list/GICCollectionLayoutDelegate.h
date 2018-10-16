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
//@property (nonatomic, assign) BOOL hasHeader;
//@property (nonatomic, assign) BOOL hasFooter;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
@property (nonatomic, assign) UIEdgeInsets interItemSpacing;

- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                       interItemSpacing:(UIEdgeInsets)interItemSpacing NS_DESIGNATED_INITIALIZER;

- (instancetype)init __unavailable;
@end


@interface GICCollectionLayoutDelegate:NSObject <ASCollectionLayoutDelegate>
@property (nonatomic,strong,readonly)GICCollectionLayoutInfo *layoutInfo;
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns;
@end
