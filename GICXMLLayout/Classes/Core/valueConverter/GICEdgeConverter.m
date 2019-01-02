//
//  GICEdgeConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICEdgeConverter.h"

@implementation GICEdgeConverter
-(NSValue *)convert:(NSString *)stringValue{
    checkDefualtValue(stringValue);
    NSArray *array = [stringValue componentsSeparatedByString:@" "];
    UIEdgeInsets edg;
    if(array.count == 4){
        edg = UIEdgeInsetsMake([GICUtils numberConverter:array[0]],
                               [GICUtils numberConverter:array[1]],
                               [GICUtils numberConverter:array[2]],
                               [GICUtils numberConverter:array[3]]);
    }else if (array.count == 2){
        edg = UIEdgeInsetsMake([GICUtils numberConverter:array[0]],
                               [GICUtils numberConverter:array[1]],
                               [GICUtils numberConverter:array[0]],
                               [GICUtils numberConverter:array[1]]);
    }else if(array.count==1){
        CGFloat v = [GICUtils numberConverter:array[0]];
        edg = UIEdgeInsetsMake(v,
                               v,
                               v,
                               v);
    }else{
        edg = UIEdgeInsetsZero;
    }
    return [NSValue valueWithUIEdgeInsets:edg];
}

-(NSValue *)convertAnimationValue:(NSValue *)from to:(NSValue *)to per:(CGFloat)per{
    UIEdgeInsets ede1 = [from UIEdgeInsetsValue];
    UIEdgeInsets ede2 = [to UIEdgeInsetsValue];
    
    UIEdgeInsets edg =  UIEdgeInsetsMake([GICUtils calcuPerValue:ede1.top to:ede2.top per:per], [GICUtils calcuPerValue:ede1.left to:ede2.left per:per], [GICUtils calcuPerValue:ede1.bottom to:ede2.bottom per:per], [GICUtils calcuPerValue:ede1.right to:ede2.right per:per]);
    
    return [NSValue valueWithUIEdgeInsets:edg];
}

-(NSString *)valueToString:(NSValue *)value{
    UIEdgeInsets edg = [value UIEdgeInsetsValue];
    return [NSString stringWithFormat:@"%@ %@ %@ %@",@(edg.top),@(edg.left),@(edg.bottom),@(edg.right)];
}
@end
