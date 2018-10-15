//
//  JSAlert.h
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/10/15.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSAlert <JSExport>
@property NSString* message;
@property NSString* title;

-(instancetype)init;
-(void)show;

JSExportAs(addButton, - (void)addButton:(NSString *)buttonName clicked:(JSValue *)callback);
@end



@interface JSAlert : NSObject<JSAlert>

@end
