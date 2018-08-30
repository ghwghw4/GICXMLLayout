//
//  GICSizeConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "GICSizeConverter.h"

@implementation GICSizeConverter
-(NSValue *)convert:(NSString *)stringValue{
    NSArray *array = [stringValue componentsSeparatedByString:@" "];
    CGSize size = CGSizeZero;
    if (array.count == 2){
        size = CGSizeMake([GICUtils numberConverter:array[0]],[GICUtils numberConverter:array[1]]);
    }else if(array.count==1){
        CGFloat v = [GICUtils numberConverter:array[0]];
        size = CGSizeMake(v,v);
    }
    return [NSValue valueWithCGSize:size];
}

-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per{
    CGSize  size1 = [from CGSizeValue];
    CGSize size2 = [to CGSizeValue];
    CGSize size = CGSizeMake([GICUtils calcuPerValue:size1.width to:size2.width per:per], [GICUtils calcuPerValue:size1.height to:size2.height per:per]);
    return [NSValue valueWithCGSize:size];
}

-(NSString *)valueToString:(NSValue *)value{
    CGSize  size = [value CGSizeValue];
    return [NSString stringWithFormat:@"%@ %@",@(size.width),@(size.height)];
}
@end
