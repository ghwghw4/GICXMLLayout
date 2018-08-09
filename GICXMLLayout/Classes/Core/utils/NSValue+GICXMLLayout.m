//
//  NSValue+GICXMLLayout.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/9.
//

#import "NSValue+GICXMLLayout.h"


ASDimension ASDimensionMakeFromString(NSString *str){
    ASDimension h = ASDimensionMake(str);
    return  ASDimensionEqualToDimension(h, ASDimensionAuto)?ASDimensionMake([str floatValue]):h;
}

@implementation NSValue (GICXMLLayout)
+ (NSValue *)valueWithASLayoutSize:(ASLayoutSize)layoutSize{
    return [NSValue value:&layoutSize withObjCType:@encode(ASLayoutSize)];
}

+ (NSValue *)valueWithASDimension:(ASDimension)dimension{
    return [NSValue value:&dimension withObjCType:@encode(ASDimension)];
}

+ (NSValue *)valueWithASDimensionPoint:(ASDimensionPoint)point{
    return [NSValue value:&point withObjCType:@encode(ASDimensionPoint)];
}

-(ASLayoutSize)ASLayoutSize{
    ASLayoutSize size;
    [self getValue:&size];
    return size;
}

-(ASDimension)ASDimension{
    ASDimension dis;
    [self getValue:&dis];
    return dis;
}

-(ASDimensionPoint)ASDimensionPoint{
    ASDimensionPoint dis;
    [self getValue:&dis];
    return dis;
}
@end
