//
//  GICCollectionLayoutDelegate.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/26.
//

#import "GICCollectionLayoutDelegate.h"
#import <AsyncDisplayKit/ASCollectionElement.h>


@implementation GICCollectionLayoutInfo
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                       interItemSpacing:(UIEdgeInsets)interItemSpacing
{
    self = [super init];
    if (self) {
        _numberOfColumns = numberOfColumns;
        _columnSpacing = columnSpacing;
        _sectionInsets = sectionInsets;
        _interItemSpacing = interItemSpacing;
    }
    return self;
}

- (BOOL)isEqualToInfo:(GICCollectionLayoutInfo *)info
{
    if (info == nil) {
        return NO;
    }
    
    return _numberOfColumns == info.numberOfColumns
    && _columnSpacing == info.columnSpacing
    && UIEdgeInsetsEqualToEdgeInsets(_sectionInsets, info.sectionInsets)
    && UIEdgeInsetsEqualToEdgeInsets(_interItemSpacing, info.interItemSpacing);
}

- (BOOL)isEqual:(id)other
{
    if (self == other) {
        return YES;
    }
    if (! [other isKindOfClass:[GICCollectionLayoutInfo class]]) {
        return NO;
    }
    return [self isEqualToInfo:other];
}

- (NSUInteger)hash
{
    // TODO:这里其实有bug的，因为属性目前是可变的，因此hash也是会变的，因此这里可能会有bug。后面想办法继续优化
    struct {
        NSInteger numberOfColumns;
        CGFloat columnSpacing;
        UIEdgeInsets sectionInsets;
        UIEdgeInsets interItemSpacing;
    } data = {
        _numberOfColumns,
        _columnSpacing,
        _sectionInsets,
        _interItemSpacing,
    };
    return ASHashBytes(&data, sizeof(data));
}
@end


@implementation GICCollectionLayoutDelegate
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
{
    self = [super init];
    if (self != nil) {
        _layoutInfo = [[GICCollectionLayoutInfo alloc] initWithNumberOfColumns:numberOfColumns
                                                           columnSpacing:10.0
                                                           sectionInsets:UIEdgeInsetsZero
                                                        interItemSpacing:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return self;
}

- (ASScrollDirection)scrollableDirections
{
    ASDisplayNodeAssertMainThread();
    return ASScrollDirectionVerticalDirections;
}

- (id)additionalInfoForLayoutWithElements:(ASElementMap *)elements
{
    ASDisplayNodeAssertMainThread();
    return self;
}

+ (ASCollectionLayoutState *)calculateLayoutWithContext:(ASCollectionLayoutContext *)context
{
    CGFloat layoutWidth = context.viewportSize.width;
    ASElementMap *elements = context.elements;
    CGFloat top = 0;
    
    GICCollectionLayoutDelegate *delegate = context.additionalInfo;
    
    GICCollectionLayoutInfo *info = delegate.layoutInfo;
    
    NSMapTable<ASCollectionElement *, UICollectionViewLayoutAttributes *> *attrsMap = [NSMapTable elementToLayoutAttributesTable];
    NSMutableArray *columnHeights = [NSMutableArray array];
    
    NSInteger numberOfSections = [elements numberOfSections];
    CGFloat footerHeight = 0;
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [elements numberOfItemsInSection:section];
        
        top += info.sectionInsets.top;
        
        // 计算header
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            ASCollectionElement *element = [elements supplementaryElementOfKind:UICollectionElementKindSectionHeader
                                                                    atIndexPath:indexPath];
            if(element){
                UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                         withIndexPath:indexPath];
                
                ASSizeRange sizeRange = [self _sizeRangeForHeaderOfSection:section withLayoutWidth:layoutWidth info:info];
                CGSize size = [element.node layoutThatFits:sizeRange].size;
                CGRect frame = CGRectMake(info.sectionInsets.left, top, size.width, size.height);
                
                attrs.frame = frame;
                [attrsMap setObject:attrs forKey:element];
                top = CGRectGetMaxY(frame);
            }
        }
        
        [columnHeights addObject:[NSMutableArray array]];
        for (NSUInteger idx = 0; idx < info.numberOfColumns; idx++) {
            [columnHeights[section] addObject:@(top)];
        }
        
        // 计算列宽
        CGFloat columnWidth = [self _columnWidthForSection:section withLayoutWidth:layoutWidth info:info];
        for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
            NSUInteger columnIndex = [self _shortestColumnIndexInSection:section withColumnHeights:columnHeights];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            ASSizeRange sizeRange = [self _sizeRangeForItem:element.node atIndexPath:indexPath withLayoutWidth:layoutWidth info:info];
            CGSize size = [element.node layoutThatFits:sizeRange].size;
            CGPoint position = CGPointMake(info.sectionInsets.left + (columnWidth + info.columnSpacing) * columnIndex,
                                           [columnHeights[section][columnIndex] floatValue]);
            CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);
            
            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:element];
            // TODO Profile and avoid boxing if there are significant retain/release overheads
            columnHeights[section][columnIndex] = @(CGRectGetMaxY(frame) + info.interItemSpacing.bottom);
        }
        
        NSUInteger columnIndex = [self _tallestColumnIndexInSection:section withColumnHeights:columnHeights];
        top = [columnHeights[section][columnIndex] floatValue] - info.interItemSpacing.bottom + info.sectionInsets.bottom;
        
        for (NSUInteger idx = 0; idx < [columnHeights[section] count]; idx++) {
            columnHeights[section][idx] = @(top);
        }
        
        // 计算footer
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            ASCollectionElement *element = [elements supplementaryElementOfKind:UICollectionElementKindSectionFooter
                                                                    atIndexPath:indexPath];
            if(element){
                UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                                         withIndexPath:indexPath];
                
                ASSizeRange sizeRange = [self _sizeRangeForFooterOfSection:section withLayoutWidth:layoutWidth info:info];
                CGSize size = [element.node layoutThatFits:sizeRange].size;
                CGRect frame = CGRectMake(info.sectionInsets.left, top, size.width, size.height);
                attrs.frame = frame;
                [attrsMap setObject:attrs forKey:element];
                top = CGRectGetMaxY(frame);
                
                footerHeight = size.height;
            }
        }
    }
    
    
    CGFloat contentHeight = [[[columnHeights lastObject] firstObject] floatValue] + footerHeight;
    CGSize contentSize = CGSizeMake(layoutWidth, contentHeight);
    return [[ASCollectionLayoutState alloc] initWithContext:context
                                                contentSize:contentSize
                             elementToLayoutAttributesTable:attrsMap];
}

+ (ASSizeRange)_sizeRangeForHeaderOfSection:(NSInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(GICCollectionLayoutInfo *)info
{
    return ASSizeRangeMake(CGSizeMake(0, 0), CGSizeMake([self _widthForSection:section withLayoutWidth:layoutWidth info:info], MAXFLOAT));
}

+ (ASSizeRange)_sizeRangeForFooterOfSection:(NSInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(GICCollectionLayoutInfo *)info
{
    return ASSizeRangeMake(CGSizeMake(0, 0), CGSizeMake([self _widthForSection:section withLayoutWidth:layoutWidth info:info], MAXFLOAT));
}

+ (CGFloat)_widthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(GICCollectionLayoutInfo *)info
{
    return layoutWidth - info.sectionInsets.left - info.sectionInsets.right;
}

+ (CGFloat)_columnWidthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(GICCollectionLayoutInfo *)info
{
    return ([self _widthForSection:section withLayoutWidth:layoutWidth info:info] - ((info.numberOfColumns - 1) * info.columnSpacing)) / info.numberOfColumns;
}

+ (NSUInteger)_shortestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue < shortestHeight) {
            index = idx;
            shortestHeight = height.floatValue;
        }
    }];
    return index;
}

+ (ASSizeRange)_sizeRangeForItem:(ASCellNode *)item atIndexPath:(NSIndexPath *)indexPath withLayoutWidth:(CGFloat)layoutWidth info:(GICCollectionLayoutInfo *)info
{
    CGFloat itemWidth = [self _columnWidthForSection:indexPath.section withLayoutWidth:layoutWidth info:info];
    itemWidth = MAX(itemWidth, 0);
    return ASSizeRangeMake(CGSizeMake(itemWidth, 0), CGSizeMake(itemWidth, CGFLOAT_MAX));
}

+ (NSUInteger)_tallestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights
{
    __block NSUInteger index = 0;
    __block CGFloat tallestHeight = 0;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue > tallestHeight) {
            index = idx;
            tallestHeight = height.floatValue;
        }
    }];
    return index;
}
@end
