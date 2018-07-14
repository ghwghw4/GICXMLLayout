//
//  GICGradientColorsConverter.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/14.
//

#import "GICGradientColorsConverter.h"

@implementation GICGradientColorsConverter
-(NSArray *)convert:(NSString *)xmlStringValue{
    NSArray *temp = [xmlStringValue componentsSeparatedByString:@" "];
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *locations =[NSMutableArray array];
    NSAssert(temp.count>0 && temp.count%2 == 0, @"必须是color location成对的数组");
    for(int i=0;i<temp.count;i++){
        if(i%2==1){
            [locations addObject:@([temp[i] floatValue])];
        }else{
            [colors addObject:(id)[GICUtils colorConverter:temp[i]].CGColor];
        }
    }
    return @[colors,locations];
}
@end
