//
//  NSValue+GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import <Foundation/Foundation.h>
typedef struct {
    ASDimension x;
    ASDimension y;
} ASDimensionPoint;

ASDISPLAYNODE_INLINE AS_WARN_UNUSED_RESULT ASDimensionPoint ASDimensionPointMake(ASDimension x, ASDimension y)
{
    ASDimensionPoint point;
    point.x = x;
    point.y = y;
    return point;
}

ASDimension ASDimensionMakeFromString(NSString *str);

@interface NSValue (GICXMLLayout)
+ (NSValue *)valueWithASLayoutSize:(ASLayoutSize)layoutSize;
+ (NSValue *)valueWithASDimension:(ASDimension)dimension;
+ (NSValue *)valueWithASDimensionPoint:(ASDimensionPoint)point;

@property(nonatomic, readonly) ASLayoutSize ASLayoutSize;
@property(nonatomic, readonly) ASDimension ASDimension;
@property(nonatomic, readonly) ASDimensionPoint ASDimensionPoint;
@end
