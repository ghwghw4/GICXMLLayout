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
        edg = UIEdgeInsetsMake([array[0] floatValue], [array[1] floatValue], [array[2] floatValue], [array[3] floatValue]);
    }else if (array.count == 2){
        edg = UIEdgeInsetsMake([array[0] floatValue], [array[1] floatValue], [array[0] floatValue], [array[1] floatValue]);
    }else{
        edg = UIEdgeInsetsZero;
    }
    return [NSValue valueWithUIEdgeInsets:edg];
}
@end
