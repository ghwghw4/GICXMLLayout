//
//  CGPointConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "CGPointConverter.h"

@implementation CGPointConverter
-(NSValue *)convert:(NSString *)stringValue{
    NSArray *array = [stringValue componentsSeparatedByString:@" "];
    CGPoint point = CGPointZero;
    if (array.count == 2){
        point = CGPointMake([GICUtils numberConverter:array[0]],[GICUtils numberConverter:array[1]]);
    }else if(array.count==1){
        CGFloat v = [GICUtils numberConverter:array[0]];
        point = CGPointMake(v,v);
    }
    return [NSValue valueWithCGPoint:point];
}

-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per{
    CGPoint size1 = [from CGPointValue];
    CGPoint size2 = [to CGPointValue];
    CGPoint size = CGPointMake([GICUtils calcuPerValue:size1.x to:size2.x per:per], [GICUtils calcuPerValue:size1.y to:size2.y per:per]);
    return [NSValue valueWithCGPoint:size];
}
@end
