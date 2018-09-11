//
//  GICScript.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/5.
//

#import <Foundation/Foundation.h>

@interface GICScript : GICBehavior{
    NSString *jsScript;
}

/**
 方法名称
 */
@property (nonatomic,readonly,strong)NSString *functionName;
@end
