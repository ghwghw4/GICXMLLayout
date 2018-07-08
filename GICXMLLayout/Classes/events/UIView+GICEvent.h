//
//  UIView+GICEvent.h
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import <UIKit/UIKit.h>
#import "GICEvent.h"

@interface UIView (GICEvent)
@property (nonatomic,strong,readonly)NSArray<GICEvent *> *gic_events;
-(void)gic_addEvent:(GICEvent *)event;
@end
