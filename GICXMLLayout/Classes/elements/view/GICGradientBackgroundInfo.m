//
//  GICGradientBackgroundInfo.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/13.
//

#import "GICGradientBackgroundInfo.h"
#import "CGPointConverter.h"
#import "GICGradientColorsConverter.h"
@implementation GICGradientBackgroundInfo

+(NSDictionary<NSString *,GICValueConverter *> *)gic_elementAttributs{
    return  @{
              @"colors":[[GICGradientColorsConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  NSArray *a= value;
                  [(GICGradientBackgroundInfo *)target setColors:a[0]];
                  [(GICGradientBackgroundInfo *)target setLocations:a[1]];
              }],
              @"start":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICGradientBackgroundInfo *)target setValue:value forKey:@"start"];
              }],
              @"end":[[CGPointConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                  [(GICGradientBackgroundInfo *)target setValue:value forKey:@"end"];
              }],
              };;
}

+(NSString *)gic_elementName{
    return @"gradient-background";
}

-(id)init{
    self = [super init];
    _end = CGPointMake(1, 1);
    return self;
}

-(void)gic_parseElementCompelete{
    
}
@end
