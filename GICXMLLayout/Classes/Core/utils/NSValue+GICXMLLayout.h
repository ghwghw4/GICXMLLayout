//
//  NSValue+GICXMLLayout.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import <Foundation/Foundation.h>

@interface NSValue (GICXMLLayout)
+ (NSValue *)valueWithASLayoutSize:(ASLayoutSize)layoutSize;
+ (NSValue *)valueWithASDimension:(ASDimension)dimension;

@property(nonatomic, readonly) ASLayoutSize ASLayoutSize;
@property(nonatomic, readonly) ASDimension ASDimension;
@end
