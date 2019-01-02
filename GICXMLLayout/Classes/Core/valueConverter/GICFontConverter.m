//
//  GICFontConverter.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/22.
//

#import "GICFontConverter.h"

@implementation GICFontConverter
-(UIFont *)convert:(NSString *)stringValue{
    checkDefualtValue(stringValue);
    NSArray *strs = [stringValue componentsSeparatedByString:@","];
    if(strs.count==1){
        return [UIFont fontWithName:strs[0] size:12];
    }else if (strs.count==2){
        return [UIFont fontWithName:strs[0] size:[strs[1] floatValue]];
    }
    return nil;
}

-(NSString *)valueToString:(UIFont *)value{
    return [value fontName];
}
@end
