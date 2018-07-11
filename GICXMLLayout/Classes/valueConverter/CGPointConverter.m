//
//  CGPointConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "CGPointConverter.h"

@implementation CGPointConverter
-(NSValue *)convert:(NSString *)xmlStringValue{
    NSArray *array = [xmlStringValue componentsSeparatedByString:@" "];
    CGPoint point = CGPointZero;
    if (array.count == 2){
        point = CGPointMake([GICUtils numberConverter:array[0]],[GICUtils numberConverter:array[1]]);
    }else if(array.count==1){
        CGFloat v = [GICUtils numberConverter:array[0]];
        point = CGPointMake(v,v);
    }
    return [NSValue valueWithCGPoint:point];
}
@end
