//
//  GICGridPanel.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/8.
//

#import "GICGridPanel.h"
#import "GICNumberConverter.h"
#import <AsyncDisplayKit/ASLayoutSpec+Subclasses.h>

#define  GridPanelAttachColumnSpanKey @"column-span" //column-span 的属性名称

struct GICGirdPanelCellHeightInfo {
    NSInteger index;
    CGFloat height;
};

@interface GICGridLayoutSpec:ASLayoutSpec
@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger columns;

@property (nonatomic,assign)CGFloat columnSpacing;
@property (nonatomic,assign)CGFloat rowSpacing;
@end

@implementation GICGridLayoutSpec
#pragma mark - ASLayoutSpec
// 计算获取最小高度的列索引
- (struct GICGirdPanelCellHeightInfo)_shortestColumnIndexWithColumnHeights:(NSArray *)columnHeights columnSpan:(NSInteger)columnSpan
{
    __block struct GICGirdPanelCellHeightInfo info = {0,CGFLOAT_MAX};
    [columnHeights enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        if(idx<=columnHeights.count - columnSpan){
            if (height.floatValue < info.height) {
                info.index = idx;
                info.height = height.floatValue;
            }
        }
    }];
    for(NSInteger i=info.index+1;(i<info.index+columnSpan) && i<columnHeights.count;i++){
        if([columnHeights[i] floatValue]>info.height){
            info.height = [columnHeights[i] floatValue];
        }
    }
    return info;
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
        id<ASLayoutElement> element = self.children[idx];
        NSInteger columnSpan = [GICGridPanel columnSpanFromElement:element];
        if(columnSpan>self.columns){
            columnSpan = self.columns;
        }
        struct GICGirdPanelCellHeightInfo cellHeightInfo = [self _shortestColumnIndexWithColumnHeights:columnHeights columnSpan:columnSpan];
        
        CGFloat width = columnWidth;
        if(columnSpan>1){
            width += (columnWidth+self.columnSpacing)*(columnSpan-1);
        }
        
        ASSizeRange sizeRange = ASSizeRangeMake(CGSizeMake(width, 0), CGSizeMake(width, CGFLOAT_MAX));
        ASLayout *sublayout = [element layoutThatFits:sizeRange];
        sublayout.position = CGPointMake((columnWidth + self.columnSpacing) * cellHeightInfo.index,
                                         cellHeightInfo.height);
        [sublayouts addObject:sublayout];
        
        for(NSInteger i=cellHeightInfo.index;i<cellHeightInfo.index +columnSpan;i++){
            columnHeights[i] = @(CGRectGetMaxY(sublayout.frame) + self.rowSpacing);
        }
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
             } withDefualtValue:@(1)],
             };
}

+(NSArray<GICAttributeValueConverter *>*)gic_elementAttachAttributs{
    return @[[[GICNumberConverter alloc] initWithName:GridPanelAttachColumnSpanKey withSetter:^(NSObject *target, id value) {
                 [[target gic_ExtensionProperties] setAttachValue:value withAttributeName:GridPanelAttachColumnSpanKey];
             } withGetter:^id(id target) {
                 return [[target gic_ExtensionProperties] attachValueWithAttributeName:GridPanelAttachColumnSpanKey];
             } withDefualtValue:@(1)]];
}

+(NSInteger)columnSpanFromElement:(id)element{
    NSInteger columnSpan = [[[element gic_ExtensionProperties] attachValueWithAttributeName:GridPanelAttachColumnSpanKey] integerValue];
    if(columnSpan<1){
        return 1;
    }
    return columnSpan;
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
