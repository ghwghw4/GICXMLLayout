//
//  GICEdgeConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICEdgeConverter.h"

@implementation GICEdgeConverter
-(NSValue *)convert:(NSString *)xmlStringValue{
    NSArray *array = [xmlStringValue componentsSeparatedByString:@" "];
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
@end
