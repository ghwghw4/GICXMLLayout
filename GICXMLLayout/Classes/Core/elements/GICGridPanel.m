//
//  GICGridPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/8.
//

#import "GICGridPanel.h"
#import "GICNumberConverter.h"
#import <AsyncDisplayKit/ASLayoutSpec+Subclasses.h>

@interface GICGridLayoutSpec:ASLayoutSpec
@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger columns;

@property (nonatomic,assign)CGFloat columnSpacing;
@property (nonatomic,assign)CGFloat rowSpacing;
@end

@implementation GICGridLayoutSpec
#pragma mark - ASLayoutSpec
// 计算获取最小高度的列索引
- (NSUInteger)_shortestColumnIndexWithColumnHeights:(NSArray *)columnHeights
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    [columnHeights enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if (height.floatValue < shortestHeight) {
            index = idx;
            shortestHeight = height.floatValue;
        }
    }];
    return index;
}

- (ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize
{
    CGFloat layoutWidth = constrainedSize.max.width;
    
    NSMutableArray *columnHeights = [NSMutableArray array];
    // 
    CGFloat columnWidth = (constrainedSize.max.width - (self.columns - 1)*self.columnSpacing)/self.columns;
    for (NSUInteger idx = 0; idx < self.columns; idx++) {
        [columnHeights addObject:@(0)];
    }
    
    NSMutableArray *sublayouts = [NSMutableArray arrayWithCapacity:self.children.count];
    for (NSUInteger idx = 0; idx < self.children.count; idx++) {
        NSUInteger columnIndex = [self _shortestColumnIndexWithColumnHeights:columnHeights];
        id<ASLayoutElement> element = self.children[idx];
        ASSizeRange sizeRange = ASSizeRangeMake(CGSizeMake(columnWidth, 0), CGSizeMake(columnWidth, CGFLOAT_MAX));
        ASLayout *sublayout = [element layoutThatFits:sizeRange];
        sublayout.position = CGPointMake((columnWidth + self.columnSpacing) * columnIndex,
                                       [columnHeights[columnIndex] floatValue]);
        [sublayouts addObject:sublayout];
        columnHeights[columnIndex] = @(CGRectGetMaxY(sublayout.frame) + self.rowSpacing);
    }
    
    __block CGFloat contentHeight = 0;
    [columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        contentHeight = MAX(contentHeight, [obj floatValue]);
    }];
    CGSize contentSize = CGSizeMake(layoutWidth, contentHeight - self.rowSpacing);
    return [ASLayout layoutWithLayoutElement:self size:ASSizeRangeClamp(constrainedSize, contentSize) sublayouts:sublayouts];
}
@end


@implementation GICGridPanel{
    NSInteger columns;
    CGFloat columnSpacing;
    CGFloat rowSpacing;
}
+(NSString *)gic_elementName{
    return @"grid-panel";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"columns":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICGridPanel *)target)->columns = MAX(1, [value integerValue]);
             } withGetter:^id(id target) {
                 return  @(((GICGridPanel *)target)->columns);
             }],
             @"column-spacing":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICGridPanel *)target)->columnSpacing = MAX(0, [value floatValue]);
             } withGetter:^id(id target) {
                 return  @(((GICGridPanel *)target)->columnSpacing);
             }],
             @"row-spacing":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 ((GICGridPanel *)target)->rowSpacing = MAX(0, [value floatValue]);
             } withGetter:^id(id target) {
                 return  @(((GICGridPanel *)target)->rowSpacing);
             }],
             };
}

-(id)init{
    self = [super init];
    columns = 1;
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    GICGridLayoutSpec *absoluteSpec = [GICGridLayoutSpec new];
    absoluteSpec.children = self.gic_displayNodes;
    absoluteSpec.columns = columns;
    absoluteSpec.columnSpacing=columnSpacing;
    absoluteSpec.rowSpacing = rowSpacing;
    return absoluteSpec;
}
@end
