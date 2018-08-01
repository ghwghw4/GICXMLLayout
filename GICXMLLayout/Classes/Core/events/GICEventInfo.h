//
//  GICEventInfo.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/9.
//

#import <Foundation/Foundation.h>

@interface GICEventInfo : NSObject
@property (nonatomic,weak,readonly)id target;
@property (nonatomic,strong)id value;

-(id)initWithTarget:(id)target withValue:(id)value;
@end
