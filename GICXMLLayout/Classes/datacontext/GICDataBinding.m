//
//  GICDataBinding.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/4.
//

#import "GICDataBinding.h"

@implementation GICDataBinding
-(void)update{
    id value = [self.dataSource objectForKey:self.dataSourceValueKey];
    if(value)
        self.valueConverter.propertySetter(self.target,value);
}
@end
