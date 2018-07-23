//
//  DataBindingViewModel.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/7/23.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataBindingUserInfo : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)NSInteger age;
@end



@interface DataBindingViewModel : NSObject{
    dispatch_source_t timer;
}
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)BOOL isOn;
@end
