//
//  GICSizeConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/11.
//

#import "GICSizeConverter.h"

@implementation GICSizeConverter
-(NSValue *)convert:(NSString *)xmlStringValue{
    NSArray *array = [xmlStringValue componentsSeparatedByString:@" "];
    CGSize size = CGSizeZero;
    if (array.count == 2){
        size = CGSizeMake([GICUtils numberConverter:array[0]],[GICUtils numberConverter:array[1]]);
    }else if(array.count==1){
        CGFloat v = [GICUtils numberConverter:array[0]];
        size = CGSizeMake(v,v);
    }
    return [NSValue valueWithCGSize:size];
}
@end
